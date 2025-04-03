//
//  SessionManager.swift
//  Cyprus
//
//  Created by Mustafa Junaid on 27/03/2025.
//


import Foundation
import FirebaseAuth

class SessionManager: ObservableObject {
    @Published var isLoggedIn = false

    init() {
        self.isLoggedIn = Auth.auth().currentUser != nil
    }

    func logout() {
        do {
            try Auth.auth().signOut()
            isLoggedIn = false
        } catch {
            print("Logout failed: \(error.localizedDescription)")
        }
    }

    func loginSucceeded() {
        isLoggedIn = true
    }
}
