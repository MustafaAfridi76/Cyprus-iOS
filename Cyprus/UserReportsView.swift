//
//  UserReportsView.swift
//  Cyprus
//
//  Created by Mustafa Junaid on 04/04/2025.
//


import SwiftUI
import FirebaseAuth

struct UserReportsView: View {
    @State private var userReports: [Report] = []
    @EnvironmentObject var session: SessionManager

    var body: some View {
        NavigationView {
            List {
                ForEach(userReports) { report in
                    NavigationLink(destination: EditReportView(report: report)) {
                        VStack(alignment: .leading, spacing: 6) {
                            Text(report.title)
                                .font(.headline)
                            Text("🧩 Type: \(report.issueType)")
                            Text("🕒 Status: \(report.status.capitalized)")
                                .fontWeight(.bold)
                            Text("📜 \(report.description)")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                        .padding(.vertical, 6)
                    }
                }
            }

            .navigationTitle("📋 My Reports")
            .onAppear {
                loadUserReports()
            }
        }
    }

    private func loadUserReports() {
        guard let currentUID = Auth.auth().currentUser?.uid else {
            print("❌ No user logged in")
            return
        }

        ReportService().fetchReports { allReports in
            self.userReports = allReports.filter { $0.userID == currentUID }
        }
    }
}
