# Roomie
**github.com/ZRich97/Roomie**

iOS Application for CSC 436 Final Project

# Notes for Milestone 3

*APIs*
* Google Sign In - Allow for Google User Authentication
* JTAppleCalendar - Easily customized calendar interface
* Firebase - Data storage and user management

*Current Features*
* Google user authentication works and is used to login and fetch user data (profile picture and name)
* Calendar adds events to the user's default calendar (should work with both Google Calendar and Apple iCloud Calendar)
* To-do list fetches recently added event from Firebase database and displays as a TableView

*Bugs*
* To-do list only stores and loads one event at a time per user account. This will be fixed by storing multiple events as an array. 
* To-do list reloads and appends events that already exist to the TableView if the View is left and re-entered. This will be fixed by more intelligent reloading of TableView when data is already present. 

*Missing Features*
* The ability to join a "household" or interact with other users. When added, Firebase will group users by Google userIDs and display each roommates name and profile picture in app.
* The ability to assign events to a specific user or specific calendar. A more sophisticated calendar view will be implemented that allows for more options and customization when creating events to allow for this functionality. 
* As of now the calendar is used only for selecting a date and pushing an event to that date on the phone's default calendar. In the final version, the calendar will display events on a specific date when a specific gesture or touch is made on the date versus selecting it. This is made possible through JTAppleCalendar. 
* Assigning events to a range of dates. This is possible using JTAppleCalendar, but not currently supported. 
