//
//  LoginViewModel.swift
//  Cyprus
//
//  Created by Mustafa Junaid on 27/03/2025.
//


import Foundation
import FirebaseAuth

class LoginViewModel: ObservableObject {
    @Published var email = ""
    @Published var password = ""
    @Published var errorMessage: String?
    @Published var isLoggedIn = false

    func login() {
        AuthService.shared.login(email: email, password: password) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(_):
                    self.isLoggedIn = true
                    print("✅ Logged in successfully.")
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                    print("❌ Login failed:", error.localizedDescription)
                }
            }
        }
    }

    func signup() {
        AuthService.shared.signUp(email: email, password: password) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(_):
                    self.isLoggedIn = true
                    print("✅ Signed up successfully.")
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                    print("❌ Signup failed:", error.localizedDescription)
                }
            }
        }
    }
}
