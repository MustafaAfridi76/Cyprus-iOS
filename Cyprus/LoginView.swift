//
//  LoginView.swift
//  Cyprus
//
//  Created by Mustafa Junaid on 27/03/2025.
//


import SwiftUI

struct LoginView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var message = ""
    @State private var isSignUp = false

    var body: some View {
        VStack(spacing: 16) {
            Text(isSignUp ? "Create Account" : "Log In")
                .font(.title)
                .bold()

            TextField("Email", text: $email)
                .autocapitalization(.none)
                .textFieldStyle(.roundedBorder)

            SecureField("Password", text: $password)
                .textFieldStyle(.roundedBorder)

            Button(isSignUp ? "Sign Up" : "Log In") {
                if isSignUp {
                    AuthService.shared.signUp(email: email, password: password) { result in
                        switch result {
                        case .success:
                            message = "✅ Signed up!"
                        case .failure(let error):
                            message = "❌ \(error.localizedDescription)"
                        }
                    }
                } else {
                    AuthService.shared.login(email: email, password: password) { result in
                        switch result {
                        case .success:
                            message = "✅ Logged in!"
                        case .failure(let error):
                            message = "❌ \(error.localizedDescription)"
                        }
                    }
                }
            }
            .buttonStyle(.borderedProminent)

            Button(isSignUp ? "Already have an account? Log In" : "Don't have an account? Sign Up") {
                isSignUp.toggle()
                message = ""
            }
            .font(.footnote)

            if !message.isEmpty {
                Text(message)
                    .foregroundColor(.gray)
            }

            Spacer()
        }
        .padding()
    }
}
