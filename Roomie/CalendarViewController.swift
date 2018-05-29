//
//  CalendarViewController.swift
//  Roomie
//
//  Created by Zachary Richardson on 5/28/18.
//  Copyright © 2018 Zachary Richardson. All rights reserved.
//

import UIKit
import JTAppleCalendar

class CalendarViewController: UIViewController {
    
    let formatter = DateFormatter()

    @IBOutlet weak var calendar: JTAppleCalendarView!
    @IBOutlet weak var tabBar: UITabBarItem!
    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    
    let outMonth = UIColor.lightGray
    let inMonth = UIColor.white
    let selectedMonth = UIColor.gray
    let currentDate = UIColor(red: 0/255, green: 154/255, blue: 193/255, alpha: 1)

    override func viewDidLoad() {
        super.viewDidLoad()
        print("CalendarViewController::viewDidLoad...")
        let swiftColor = UIColor(red: 0/255, green: 154/255, blue: 193/255, alpha: 1)
        self.view.backgroundColor = swiftColor;

        setupCalendar()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
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
            validCell.selectedView.isHidden = false
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
    

}

extension CalendarViewController: JTAppleCalendarViewDataSource {

    // Establish Calendar Display Info
    func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters {
        formatter.dateFormat = "yyyy MM dd"
        formatter.timeZone = Calendar.current.timeZone
        formatter.locale = Calendar.current.locale
        
        let startDate = formatter.date(from:"2017 01 01")!
        let endDate = formatter.date(from:"2017 12 31")!
        
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
