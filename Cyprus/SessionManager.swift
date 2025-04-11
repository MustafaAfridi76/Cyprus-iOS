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
    @Published var isAdmin = false
    private let adminUID = "bqSXFORzAoUL8J1naTpsr58Lsmt2"


    init() {
        if let user = Auth.auth().currentUser {
            self.isLoggedIn = true
            self.isAdmin = user.uid == adminUID
        }
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
        if let user = Auth.auth().currentUser {
            self.isLoggedIn = true
            self.isAdmin = user.uid == adminUID
        }
    }
}
