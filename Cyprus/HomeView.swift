//
//  HomeView.swift
//  Cyprus
//
//  Created by Mustafa Junaid on 27/03/2025.
//

import SwiftUI

struct HomeView: View {
    var session: SessionManager

    var body: some View {
        VStack(spacing: 20) {
            Text("🎉 You're logged in!")
                .font(.largeTitle)
                .bold()
            Button("Log Out") {
                session.logout()
            }
            .buttonStyle(.borderedProminent)
        }
        .padding()
    }
}

