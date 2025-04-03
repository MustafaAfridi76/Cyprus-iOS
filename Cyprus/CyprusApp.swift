//
//  CyprusApp.swift
//  Cyprus
//
//  Created by Mustafa Junaid on 26/03/2025.
//

import SwiftUI
import FirebaseCore
import FirebaseAuth

//APP DELIGATION DEFAULT
class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure() //IMPORTANT ⚠️
      print("Firebase configured bitchhh.")
      
      print("FirebaseAuth app name: \(Auth.auth().app?.name ?? "Unavailable")")
      
    return true
  }
}


@main
struct CyprusApp: App {
  // register app delegate for Firebase setup
  @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @StateObject var session = SessionManager()

    var body: some Scene {
        WindowGroup {
            if session.isLoggedIn {
                SubmitReportView()
                    .environmentObject(session)
                // i want to add it here so it goes there right after auth view
//                HomeView(session: session) // ⬅️ Replace with your main view
            } else {
                AuthView()
                    .environmentObject(session)
            }
        }
    }

  }

