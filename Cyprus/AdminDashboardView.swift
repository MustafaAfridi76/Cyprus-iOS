//
//  AdminDashboardView.swift
//  Cyprus
//
//  Created by Mustafa Junaid on 04/04/2025.
//


import SwiftUI
import FirebaseFirestore

struct AdminDashboardView: View {
    @State private var reports: [Report] = []
    @EnvironmentObject var session: SessionManager

    var body: some View {
        NavigationView {
            List {
                ForEach(reports) { report in
                    VStack(alignment: .leading, spacing: 8) {
                        Text("📍 \(report.title)")
                            .font(.headline)
                        Text("Type: \(report.issueType)")
                        Text("Status: \(report.status)")
                        Text("Description: \(report.description)")
                            .font(.subheadline)

                        HStack {
                            Button("✅ Mark Resolved") {
                                updateReportStatus(report, to: "resolved")
                            }
                            .buttonStyle(.borderedProminent)
                            .disabled(report.status.lowercased() == "resolved") // disable if already resolved
                            .opacity(report.status.lowercased() == "resolved" ? 0.5 : 1.0) // make it visually obvious


                            Button("❌ Delete") {
                                deleteReport(report)
                            }
                            .buttonStyle(.bordered)
                            .foregroundColor(.red)
                        }
                    }
                    .padding(.vertical, 8)
                }
                Button("Log Out") {
                    session.logout()
                }
                .buttonStyle(.borderedProminent)
            }
            .navigationTitle("🛠 Admin Panel")
            .onAppear {
                loadReports()
            }
            
            
        }
    }

    private func loadReports() {
        ReportService().fetchReports { fetched in
            self.reports = fetched.filter { $0.status != "." }
        }
    }

    private func updateReportStatus(_ report: Report, to newStatus: String) {
        let db = Firestore.firestore()
        guard let id = report.id else { return }

        db.collection("Reports").document(id).updateData(["status": newStatus]) { error in
            if let error = error {
                print("Error updating report: \(error)")
            } else {
                loadReports() // refresh
            }
        }
    }

    private func deleteReport(_ report: Report) {
        let db = Firestore.firestore()
        guard let id = report.id else { return }

        db.collection("Reports").document(id).delete { error in
            if let error = error {
                print("Error deleting report: \(error)")
            } else {
                loadReports()
            }
        }
    }
}
