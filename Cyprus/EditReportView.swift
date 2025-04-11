//
//  EditReportView.swift
//  Cyprus
//
//  Created by Mustafa Junaid on 04/04/2025.
//


import SwiftUI
import FirebaseFirestore
import FirebaseAuth
import MapKit

struct EditReportView: View {
    @Environment(\.presentationMode) var presentationMode
    @State var report: Report

    @State private var title: String
    @State private var description: String
    @State private var selectedIssueType: String
    let issueTypes = ["Damage", "Crime", "Garbage", "Accident", "Other"]

    init(report: Report) {
        self._report = State(initialValue: report)
        self._title = State(initialValue: report.title)
        self._description = State(initialValue: report.description)
        self._selectedIssueType = State(initialValue: report.issueType)
    }

    var body: some View {
        Form {
            Section(header: Text("Edit Report")) {
                TextField("Title", text: $title)
                TextField("Description", text: $description)

                Picker("Issue Type", selection: $selectedIssueType) {
                    ForEach(issueTypes, id: \.self) { type in
                        Text(type)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
            }

            Section {
                Button("💾 Save Changes") {
                    updateReport()
                }
                .disabled(report.status == "resolved")

                    Button("🗑 Delete Report", role: .destructive) {
                        deleteReport()
                    }
                
            }
        }
        .navigationTitle("Edit Report")
    }

    private func updateReport() {
        guard let id = report.id else {
            print("❌ Missing report ID")
            return
        }

        let db = Firestore.firestore()
        let data: [String: Any] = [
            "title": title,
            "description": description,
            "issueType": selectedIssueType
        ]

        db.collection("Reports").document(id).updateData(data) { error in
            if let error = error {
                print("❌ Firestore update failed: \(error.localizedDescription)")
            } else {
                print("✅ Firestore update success!")
                presentationMode.wrappedValue.dismiss()
            }
        }
    }


    private func deleteReport() {
        guard let id = report.id else { return }

        Firestore.firestore().collection("Reports").document(id).delete { error in
            if let error = error {
                print("Error deleting report: \(error)")
            } else {
                presentationMode.wrappedValue.dismiss()
            }
        }
    }
}
