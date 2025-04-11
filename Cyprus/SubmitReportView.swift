//
//  SubmitReportView.swift
//  Cyprus
//
//  Created by Mustafa Junaid on 27/03/2025.

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
    @State private var selectedIssueType = "Pothole"

    let issueTypes = ["Damage", "Crime", "Garbage", "Accident", "Other"]

    @State private var selectedLocation = CLLocationCoordinate2D(latitude: 43.651070, longitude: -79.347015)

    var body: some View {
        NavigationView {
            ZStack {
                LinearGradient(gradient: Gradient(colors: [Color(red: 0.012, green: 0.224, blue: 0.290), .black]),
                               startPoint: .top,
                               endPoint: .bottom)
                    .ignoresSafeArea()

                VStack(spacing: 20) {
                    Text("Submit a Report")
                        .font(.largeTitle.bold())
                        .foregroundColor(.white)

                    MapSelectorView(selectedCoordinate: $selectedLocation)

                    Picker("Select Issue Type", selection: $selectedIssueType) {
                        ForEach(issueTypes, id: \.self) { type in
                            Text(type)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .padding(.horizontal)

                    TextField("Title", text: $title)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.horizontal)

                    TextField("Description", text: $description)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.horizontal)

                    HStack(spacing: 16) {
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

                        NavigationLink(destination: ReportsMapView()) {
                            HStack {
                                Image(systemName: "map.fill")
                                Text("View Reports")
                            }
                            .padding()
                            .background(Color.white.opacity(0.15))
                            .foregroundColor(.white)
                            .cornerRadius(12)
                            .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.white.opacity(0.2)))
                        }
                    }
                    .padding(.horizontal)

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

                    Spacer()
                }
            }
        }
    }

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

        ReportService().fetchReports { existingReports in
            let threshold: CLLocationDistance = 100
            let isDuplicate = existingReports.contains { report in
                let reportLocation = CLLocationCoordinate2D(latitude: report.latitude, longitude: report.longitude)
                let distance = reportLocation.distance(to: selectedLocation)
                return distance < threshold && report.issueType == selectedIssueType
            }

            let report = Report(
                id: nil,
                title: title,
                description: description,
                issueType: selectedIssueType,
                timestamp: Date(),
                latitude: selectedLocation.latitude,
                longitude: selectedLocation.longitude,
                status: isDuplicate ? "pending (possible duplicate)" : "pending",
                userID: userID
            )

            ReportService().submitReport(report) { error in
                isSubmitting = false
                if let error = error {
                    statusMessage = "❌ Failed: \(error.localizedDescription)"
                } else {
                    statusMessage = isDuplicate ? "⚠️ Submitted – similar issue already reported nearby." : "✅ Report submitted!"
                    title = ""
                    description = ""
                }
            }
        }
    }
}
