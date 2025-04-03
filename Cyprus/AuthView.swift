//
//  AuthView.swift
//  Cyprus
//
//  Created by Mustafa Junaid on 27/03/2025.
//
import SwiftUI
import FirebaseAuth // 🆕 Added for Firebase Authentication logic

struct AuthView: View {
    // 🧠 Auth-related state variables
    @State private var email = ""
    @State private var password = ""
    @State private var isLoginMode = true
    @State private var statusMessage = ""
    @EnvironmentObject var session: SessionManager
    
    

    var body: some View {
        NavigationView {
            ZStack {
                // 🎨 Gradient background
                LinearGradient(gradient: Gradient(colors: [Color(red: 0.012, green: 0.224, blue: 0.290, opacity: 0.8), Color.black.opacity(1)]),
                               startPoint: .topLeading,
                               endPoint: .bottomTrailing)
                    .ignoresSafeArea()

                VStack(spacing: 28) {
                    // 🖼 Logo Image
                    Image("Logo1")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 130, height: 130)
                        .clipShape(RoundedRectangle(cornerRadius: 4))
                        .shadow(radius: 10)
                        .padding(.bottom, 0)

                    // 🔤 Title & Mode Toggle
                    Text(isLoginMode ? "Welcome Back" : "Create Account")
                        .font(.largeTitle.bold())
                        .foregroundColor(.white)
                        .padding(.top, 0)

                    // 🔄 Picker for login/signup toggle
                    Picker(selection: $isLoginMode, label: Text("Login Mode")) {
                        Text("Login").tag(true).foregroundColor(.gray)
                        Text("Sign Up").tag(false).foregroundColor(.gray)
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .padding(.horizontal)

                    // 📧 Email Field
                    HStack {
                        Image(systemName: "envelope.fill")
                            .foregroundColor(.white)
                        TextField("Email", text: $email)
                            .keyboardType(.emailAddress)
                            .autocapitalization(.none)
                            .foregroundColor(.white)
                    }
                    .padding()
                    .background(Color.white.opacity(0.3))
                    .cornerRadius(12)
                    .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.white.opacity(0.2)))
                    .padding(.horizontal)

                    // 🔒 Password Field
                    HStack {
                        Image(systemName: "lock.fill")
                            .foregroundColor(.white)
                        SecureField("Password", text: $password)
                            .foregroundColor(.white)
                    }
                    .padding()
                    .background(Color.white.opacity(0.3))
                    .cornerRadius(12)
                    .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.white.opacity(0.3)))
                    .padding(.horizontal)

                    // 🔘 Action Button (Login/Signup)
                    Button(action: handleAction) {
                        Text(isLoginMode ? "Log In" : "Sign Up")
                            .fontWeight(.semibold)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.white.opacity(0.4))
                            .foregroundColor(.white)
                            .cornerRadius(12)
                            .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.white.opacity(0.4)))
                    }
                    .padding(.horizontal)
                    .shadow(color: .black.opacity(0.3), radius: 10, x: 0, y: 5)

                    // 🟡 Status Message
                    if !statusMessage.isEmpty {
                        Text(statusMessage)
                            .foregroundColor(.white)
                            .font(.subheadline)
                            .padding(.top)
                            .transition(.opacity)
                    }

                    Spacer()
                }
                .padding(.bottom, 40)
            }
            .navigationBarHidden(true)
        }
//        .onAppear {
//                ReportService().submitDummyReport()
//            }
    }

    // 💡 This is the main authentication logic
    private func handleAction() {
        guard !email.isEmpty, !password.isEmpty else {
            statusMessage = "Please fill in all fields."
            return
        }

        if isLoginMode {
            // 🔐 Login flow
            AuthService.shared.login(email: email, password: password) { result in
                switch result {
                case .success(_):
                    statusMessage = "\u{2705} Logged in as \(email)"
                    session.loginSucceeded()
                case .failure(let error):
                    statusMessage = "\u{274C} Login failed: \(error.localizedDescription)"
                }
            }
        } else {
            // 🆕 Sign-up flow
            AuthService.shared.signUp(email: email, password: password) { result in
                switch result {
                case .success(_):
                    statusMessage = "\u{1F389} Account created for \(email)"
                    session.loginSucceeded()
                case .failure(let error):
                    statusMessage = "\u{274C} Signup failed: \(error.localizedDescription)"
                }
            }
        }
    }
}
