//
//  ReportsMapView.swift
//  Cyprus
//
//  Created by Mustafa Junaid on 03/04/2025.
//


import SwiftUI
import MapKit
import FirebaseFirestore

struct ReportsMapView: View {
    @State private var reports: [Report] = []
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 43.65774, longitude: -79.38080),
        span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
    )
    
    // State to trigger navigation
    @State private var navigateToSubmit = false
    @State private var navigateToSubmitReport = false
    

    var body: some View {
        NavigationView {
            ZStack(alignment: .bottom) {
                Map(coordinateRegion: $region, annotationItems: reports) { report in
                    MapAnnotation(coordinate: CLLocationCoordinate2D(latitude: report.latitude, longitude: report.longitude)) {
                        VStack {
                            Image(systemName: "mappin.circle.fill")
                                .font(.title)
                                .foregroundColor(.red)

                            VStack(alignment: .leading, spacing: 4) {
                                Text(report.title)
                                    .font(.headline)
                                Text("Type: \(report.issueType)")
                                    .font(.subheadline)
                                Text("Status: \(report.status)")
                                    .font(.caption)
                                Text(report.description)
                                    .font(.caption2)
                            }
                            .padding(8)
                            .background(.ultraThinMaterial)
                            .cornerRadius(10)
                            .shadow(radius: 4)
                        }
                    }
                }
                .edgesIgnoringSafeArea(.all)

                HStack {
//                    Button("Submit report") {
//                        // TO DO: Add logic later
//                    }
//                    .buttonStyle(.borderedProminent)

                    // 👇 Submit Report Button now triggers navigation
                    Button("View my Reports") {
                        navigateToSubmit = true
                    }
                    .buttonStyle(.borderedProminent)
                }
                .padding()
//                .background(.ultraThinMaterial)

                // 👇 Hidden NavigationLink that's triggered by state
                NavigationLink(
                    destination: UserReportsView(),
                    isActive: $navigateToSubmit,
                    label: {
                        EmptyView()
                    })
                    .hidden()
                NavigationLink(
                    destination: SubmitReportView(),
                    isActive: $navigateToSubmitReport,
                    label: {
                        EmptyView()
                    })
                    .hidden()
            }
            .onAppear {
                ReportService().fetchReports { fetched in
                    self.reports = fetched
                }
            }
        }
    }
}
