<p align="center">
<img src="https://raw.githubusercontent.com/ZRich97/Roomie/master/Roomie/img/icon.png?raw=true" alt="Roomie Icon"/>
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
<img src="https://raw.githubusercontent.com/ZRich97/Roomie/master/Roomie/img/homescreen.jpeg?raw=true" alt="Roomie Homescreen"/>
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
* EventKit - Adds created events to user's default calendar application
**Note: As stated by another student in class (I meant to mention this in my presentation as well), the Google Calendair API is only available in Objective-C and I elected to use EventKit over Google Calendar for this reason. EventKit will add the new event to the user's default calendar, which in a simulator should always be the default Apple Calendar.**

**Features To Add**
* Prettier Calendar - TableView below Calendar that show events taking place on the selected date. Double-tapping on a date will allow the user to add an event on that day.
* More Info For Tasks/Events - I would like Tasks and Events to record which user created them, and handle Date/Time better. 
* Notifications - In addition to adding Events to the user's calendar, if Tasks had more Date/Time information they would be useful as Notifications for the user. 
* Venmo / Paypal Integration - Being able to add a monetary charge to a Task would be useful for households, and most college students regularly use both of these services. 
* Assigning events to a range of dates. This is possible using JTAppleCalendar, but not currently supported. 

**Bugs**
* Occasionally the Google login will consider a user as "new" when they already have a Google-authorized account. This causes the user to be trapped in account creation. I have not been able to reliably reproduce this bug, as it will occur seemingly randomly when launching application after multiple successful logins. 

**Firebase Data**
<p align="center">
<img src="https://raw.githubusercontent.com/ZRich97/Roomie/master/Roomie/img/Firebase.png?raw=true" alt="Roomie Firebase Structure"/>
</p>



