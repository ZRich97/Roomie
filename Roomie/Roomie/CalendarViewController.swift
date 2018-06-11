//
//  CalendarViewController.swift
//  Roomie
//
//  Created by Zachary Richardson on 5/28/18.
//  Copyright © 2018 Zachary Richardson. All rights reserved.
//

import UIKit
import JTAppleCalendar
import EventKit
import Firebase
import GoogleSignIn
import CodableFirebase

class CalendarViewController: UIViewController {
   
    @IBOutlet weak var calendar: JTAppleCalendarView!
    @IBOutlet weak var tabBar: UITabBarItem!
    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    
    @IBOutlet weak var eventText: UITextField!
    @IBOutlet weak var eventButton: UIButton!
    
    let formatter = DateFormatter()
    var ref: DatabaseReference!
    var googleUser: GIDGoogleUser!
    var countEvents = 0
    var roomieUser: RoomieUser!

    let outMonth = UIColor.lightGray
    let inMonth = UIColor.white
    let selectedMonth = UIColor.black
    let currentDate = UIColor(red: 0/255, green: 154/255, blue: 193/255, alpha: 1)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if (GIDSignIn.sharedInstance().hasAuthInKeychain()) {
            googleUser = GIDSignIn.sharedInstance().currentUser
        }
        ref = Database.database().reference()
        ref.keepSynced(true)
        loadUserData()
        setupCalendar()
    }
    
    func loadUserData()
    {
        ref.child("users").child(googleUser.userID).observeSingleEvent(of: .value, with: { snapshot in
            guard let value = snapshot.value else { return }
            do {
                self.roomieUser = try FirebaseDecoder().decode(RoomieUser.self, from: value)
            } catch let error {
                print(error)
            }
        })
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        checkPermissions()
    }
    
    @IBAction func addEvent(_ sender: Any) {
        let eventStore:EKEventStore = EKEventStore()
        for date in calendar.selectedDates
        {
            let event:EKEvent = EKEvent(eventStore: eventStore)
            event.title = eventText.text
            event.startDate = date
            event.endDate = date.addingTimeInterval(120)
            event.notes = "Added via Roomie"
            event.calendar = eventStore.defaultCalendarForNewEvents
            do
            {
                try eventStore.save(event, span: .thisEvent)
                addEventToDatabase(date: event.startDate, description: event.title)
            }
            catch let error as NSError
            {
                print("Error: \(error)")
            }
        }
    }
    
    func checkPermissions()
    {
        let eventStore:EKEventStore = EKEventStore()
        
        switch EKEventStore.authorizationStatus(for: .event)
        {
            case .authorized:
                populateCalendar()
            case .notDetermined:
                print("NOTDETERMINED")
                eventStore.requestAccess(to: .event, completion: {(granted, error) in
                    if let error = error {
                        print(error.localizedDescription)
                    }
                    else
                    {
                        if granted
                        {
                            self.populateCalendar()
                        }
                    }
            })
            case .denied:
                    print("DENIED")
            case .restricted:
                    print("RESTRICTED")
        }
        
    }
        
    func populateCalendar()
    {
        //TODO: Load events
    }
    
    func setupCalendar()
    {
        // Set Data Sources
        calendar.calendarDelegate = self
        calendar.calendarDataSource = self
        
        // Spacing
        calendar.minimumLineSpacing = 0
        calendar.minimumInteritemSpacing = 0
        
        // Year/Month Labels
        calendar.visibleDates { (visibleDates) in
            self.handleCalendarLabels(from: visibleDates)
        }
        
        // Enable multiple selections
        // calendar.allowsMultipleSelection  = true
    }

    // Handles Coloring Of Cells
    func handleCalendarColor(view: JTAppleCell?, cellState: CellState) {
        guard let validCell = view as? CalendarCell else { return }
        if(cellState.isSelected)
        {
            validCell.dateLabel.textColor = selectedMonth
        }
        else
        {
            if(cellState.dateBelongsTo == .thisMonth)
            {
                validCell.dateLabel.textColor = inMonth
            }
            else
            {
                validCell.dateLabel.textColor = outMonth
            }
        }
    }
    
    
    // Handles Hiding/Showing Selected Cells
    func handleCalendarSelected(view: JTAppleCell?, cellState: CellState) {
        guard let validCell = view as? CalendarCell else { return }
        if(validCell.isSelected)
        {
            //validCell.selectedView.isHidden = false
        }
        else
        {
            validCell.selectedView.isHidden = true
        }
    }
    
    func handleCalendarLabels(from visibleDates: DateSegmentInfo)
    {
        let date = visibleDates.monthDates.first!.date
        
        formatter.dateFormat = "yyyy"
        yearLabel.text = formatter.string(from: date)
        
        formatter.dateFormat = "MMMM"
        monthLabel.text = formatter.string(from: date)
    }
    
    func addEventToDatabase(date: Date, description: String)
    {
        ref.child("households").child(roomieUser.houseID).observeSingleEvent(of: .value, with: { snapshot in
            guard let value = snapshot.value else { return }
            do {
                var house = try FirebaseDecoder().decode(RoomieHousehold.self, from: value)
                if house.eventList == nil
                {
                    house.eventList = [RoomieEvent]()
                }
                house.eventList.append(RoomieEvent(date: date, description: description))
                let data = try! FirebaseEncoder().encode(house)
                self.ref.child("households").child(self.roomieUser.houseID).setValue(data)
            } catch let error {
                print(error)
            }
        })
    }
    
}

extension CalendarViewController: JTAppleCalendarViewDataSource {

    // Establish Calendar Display Info
    func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters {
        formatter.dateFormat = "yyyy MM dd"
        formatter.timeZone = Calendar.current.timeZone
        formatter.locale = Calendar.current.locale
        let startDate = Date()
        let endDate = formatter.date(from:"2018 12 31")!
        let parameters = ConfigurationParameters(startDate: startDate, endDate: endDate)
        return parameters
    }
}

extension CalendarViewController: JTAppleCalendarViewDelegate {
    // Create Cell
    func calendar(_ calendar: JTAppleCalendarView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTAppleCell {
        let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: "myCell", for: indexPath) as! CalendarCell
        cell.dateLabel.text = cellState.text
        cell.selectedView.layer.cornerRadius = 15;
        cell.selectedView.layer.masksToBounds = true;
        cell.selectedView.isHidden = true;
        handleCalendarSelected(view: cell, cellState: cellState)
        handleCalendarColor(view: cell, cellState: cellState)
        return cell
    }
    
    // TODO: Necessary For Delegate?
    func calendar(_ calendar: JTAppleCalendarView, willDisplay cell: JTAppleCell, forItemAt date: Date, cellState: CellState, indexPath: IndexPath) {
    }
    
    // Select A Cell
    func calendar(_ calendar: JTAppleCalendarView, didSelectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        handleCalendarSelected(view: cell, cellState: cellState)
        handleCalendarColor(view: cell, cellState: cellState)
    }
    
    // Deselect A Cell
    func calendar(_ calendar: JTAppleCalendarView, didDeselectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        handleCalendarSelected(view: cell, cellState: cellState)
        handleCalendarColor(view: cell, cellState: cellState)
    }
    
    // Scroll
    func calendar(_ calendar: JTAppleCalendarView, didScrollToDateSegmentWith visibleDates: DateSegmentInfo) {
        handleCalendarLabels(from: visibleDates)
    }
}
