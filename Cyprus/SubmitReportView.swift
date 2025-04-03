//
//  SubmitReportView.swift
//  Cyprus
//
//  Created by Mustafa Junaid on 27/03/2025.
//
import SwiftUI
import CoreLocation
import FirebaseFirestore
import FirebaseAuth
import MapKit

struct SubmitReportView: View {
    @EnvironmentObject var session: SessionManager
    @State private var title = ""
    @State private var description = ""
    @State private var statusMessage = ""
    @State private var isSubmitting = false
    @State private var selectedIssueType = "Pothole" // 🆕 Default issue type

    let issueTypes = ["Damage", "Crime", "Garbage", "Accident", "Other"]


    // 🗺️ This is the selected coordinate from the Map
    @State private var selectedLocation = CLLocationCoordinate2D(latitude: 43.651070, longitude: -79.347015)

    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [Color(red: 0.012, green: 0.224, blue: 0.290), .black]),
                           startPoint: .top,
                           endPoint: .bottom)
                .ignoresSafeArea()

            VStack(spacing: 20) {
                Text("Submit a Report")
                    .font(.largeTitle.bold())
                    .foregroundColor(.white)

                // 📌 Map selector for coordinates
                MapSelectorView(selectedCoordinate: $selectedLocation)
                
                // 🧰 Issue Type Picker
                Picker("Select Issue Type", selection: $selectedIssueType) {
                    ForEach(issueTypes, id: \.self) { type in
                        Text(type)
                    }
                }
                .pickerStyle(SegmentedPickerStyle()) // or .menu if you prefer dropdown
                .padding(.horizontal)


                // 📝 Title field
                TextField("Title", text: $title)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)

                // 📜 Description
                TextField("Description", text: $description)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)

                // 🚀 Submit Button
                Button(action: submitReport) {
                    HStack {
                        if isSubmitting {
                            ProgressView()
                        } else {
                            Image(systemName: "paperplane.fill")
                        }
                        Text(isSubmitting ? "Sending..." : "Submit Report")
                            .fontWeight(.medium)
                    }
                    .padding()
                    .background(Color.white.opacity(0.15))
                    .foregroundColor(.white)
                    .cornerRadius(12)
                    .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.white.opacity(0.2)))
                    .animation(.easeInOut, value: isSubmitting)
                }
                .disabled(isSubmitting)
                .padding()

                // 💬 Status
                if !statusMessage.isEmpty {
                    Text(statusMessage)
                        .foregroundColor(.white)
                        .font(.subheadline)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                }

                Button("Log Out") {
                    session.logout()
                }
                .buttonStyle(.borderedProminent)

//                Spacer()
            }
//            .padding()
        }
    }

    // 📤 Submits the report to Firestore
    private func submitReport() {
        guard !title.isEmpty, !description.isEmpty else {
            statusMessage = "Please fill out all fields."
            return
        }

        guard let userID = Auth.auth().currentUser?.uid else {
            statusMessage = "❌ You must be logged in to submit a report."
            return
        }

        isSubmitting = true

        let report = Report(
            id: nil,
            title: title,
            description: description,
            issueType: selectedIssueType,
            timestamp: Date(),
            latitude: selectedLocation.latitude,
            longitude: selectedLocation.longitude,
            status: "pending",
            userID: userID
        )

        ReportService().submitReport(report) { error in
            isSubmitting = false
            if let error = error {
                statusMessage = "❌ Failed: \(error.localizedDescription)"
            } else {
                statusMessage = "✅ Report submitted!"
                title = ""
                description = ""
            }
        }
    }
}
