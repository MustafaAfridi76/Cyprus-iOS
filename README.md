Topic: Cypress
Department of Computer Science, Toronto Metropolitan University
CPS406: Introduction to Software Engineering


Dr. Vojislav B. Mišić
Sprint - 3
Thursday April 10th 2025

Team Members (Grp. 24): 
Mustafa Junaid Khan Afridi - 501341943
Basith Abdul - 501266179
Hizb Patel - 501238812
Syed Najeeb Ahmed - 501235571 
Harshit Purohit - 501220074
Afeefuddin Mohammed - 501187916



Project Description--------------------------------
Cypress is a community issue reporting iOS application built using SwiftUI and Firebase. Users can submit reports about local issues such as potholes, garbage, or crimes, view reports on a map, and manage their submissions. Admin users have access to a dashboard for resolving or deleting reports.

Features--------------------------------

Authentication-------------------------------
- Sign up and login using email and password
- Persistent session handling
- Admin detection based on user ID

Report Submission----------------------------------------------------------------
- Users can submit a report with a title, description, issue type, and location (selected via MapKit)
- Nearby duplicates are detected and flagged automatically
- Animated submit button with status messages and feedback

Map Integration--------------------------------
- Users can select a location on an interactive map when submitting a report
- All reports are displayed on a map with annotations

Report Management------------------------------
- Regular users can:
  - View their submitted reports
  - Edit or delete pending reports
- Admin users can:
  - View all active reports
  - Resolve or delete any report

File Structure Overview-------------------------------

App Entry Point--------------------------------
- `CyprusApp.swift`: Initializes Firebase and routes users to the appropriate view based on authentication and role (admin or regular user)

Authentication--------------------------------
- `AuthView.swift`: Login and sign-up screen with user-friendly design
- `AuthService.swift`: Handles Firebase authentication logic
- `SessionManager.swift`: Tracks login state and determines if the user is an admin

Core Views--------------------------------
- `SubmitReportView.swift`: Form for submitting reports with embedded map selector
- `MapSelectorView.swift`: View for choosing a location using MapKit
- `ReportsMapView.swift`: Displays all reports on an interactive map
- `UserReportsView.swift`: Allows users to manage their own submitted reports
- `EditReportView.swift`: Enables editing or deleting pending reports
- `AdminDashboardView.swift`: Allows admins to resolve or delete any report

Data Management--------------------------------
- `ReportService.swift`: Handles fetching and submitting reports to Firestore
- `Report.swift`: Codable struct representing a report for Firestore storage

Firebase Integration--------------------------------
- Firebase is initialized in `AppDelegate`
- `GoogleService-Info.plist` is included for Firebase setup
- Firestore collections:
  - `Reports`: stores all submitted reports

Admin Access--------------------------------
The following UID is hardcoded to identify the admin user:
```swift
let adminUID = "bqSXFORzAoUL8J1naTpsr58Lsmt2"
```

Dependencies--------------------------------
- SwiftUI
- Firebase (Authentication and Firestore)
- MapKit

Getting Started--------------------------------
1. Clone the repository
2. Open the project in Xcode (Swift Package Manager is used for Firebase dependencies)
3. Ensure `GoogleService-Info.plist` is added to the Xcode project
4. Build and run the app on an iOS simulator or device (iOS 15 or newer recommended)

Known Limitations--------------------------------
- Currently no image upload support for reports
- Push notifications are not implemented
- Admin UID is hardcoded for simplicity

Credits--------------------------------
- Design and logic and software development: Mustafa Junaid
- Product backlog list and requirement list: Hizb Patel 
Syed Najeeb Ahmed 
Harshit Purohit 
Afeefuddin Mohammed

