<p align="center">
<img src="https://github.com/ZRich97/Roomie/Roomie/img/icon.png?raw=true" alt="Roomie Icon"/>
</p>

# Roomie
**github.com/ZRich97/Roomie**
iOS Application for CSC 436 Final Project

# Notes for Final Submission

**Logging In**
* Upon install, you will be presented with a Google login button. To log into my pre-made household, you may use the testing credentials below: 
Email: zacktest97@gmail.com
Password: algorithm

* Once logged in, you should be presented with this screen immediately. 
<p align="center">
<img src="https://github.com/ZRich97/Roomie/Roomie/img/homescreen.jpeg?raw=true" alt="Roomie Homescreen"/>
</p>

* From here you can select a roommate to add a task to, add a task to yourself ("test") or go to either the Calendar or Event pages. 
* To create a new household or make a new user in my pre-existing household you must logout using the button in the top left of the homescreen. 
* To join the existing household, login with your own Google account and enter the following credentials
Username: Anything except rgolmass, zdrichar, or tester. The app will not allow you to create an account with a pre-existing username
House ID: calpoly
House Password: password

* To create a new household, enter your own custom values for the above fields. 

**APIs**
* Google Sign In - Allow for Google User Authentication
* JTAppleCalendar - Easily customized calendar interface
* Firebase - Data storage and user management
* Codable Firebase - Easier Codable->Firebase->Codable parsing

**Current Features**


**Bugs**


**Missing Features**
* The ability to assign events to a specific calendar. A more sophisticated calendar view will be implemented that allows for more options and customization when creating events to allow for this functionality. 
* As of now the calendar is used only for selecting a date and pushing an event to that date on the phone's default calendar. In the final version, the calendar will display events on a specific date when a specific gesture or touch is made on the date versus selecting it. This is made possible through JTAppleCalendar. 
* Assigning events to a range of dates. This is possible using JTAppleCalendar, but not currently supported. 

**Misc**
* As stated by another student in class (I meant to mention this in my presentation as well), the Google Calendair API is only available in Objective-C and I elected to use EventKit over Google Calendar for this reason. EventKit will add the new event to the user's default calendar, which in a simulator should always be the default Apple Calendar. 
