//
//  ContentView.swift
//  Cyprus
//
//  Created by Mustafa Junaid on 26/03/2025.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, worldddd!")
            
            Button("Sign Up") {
                AuthService.shared.signUp(email: "test@test.com", password: "123456") { result in
                    switch result {
                    case .success(let user):
                        print("Signed up as \(user.user.email ?? "")")
                    case .failure(let error):
                        print("Sign-up error: \(error.localizedDescription)")
                    }
                }
            }

            Button("Login") {
                AuthService.shared.login(email: "test@test.com", password: "123456") { result in
                    switch result {
                    case .success(let user):
                        print("Logged in as \(user.user.email ?? "")")
                    case .failure(let error):
                        print("Login error: \(error.localizedDescription)")
                    }
                }
            }

        }
        .padding()
    }
}

#Preview {
    ContentView()
}
