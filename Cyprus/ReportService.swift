//
//  Report.swift
//  Cyprus
//
//  Created by Mustafa Junaid on 27/03/2025.
//


import FirebaseFirestore
import FirebaseAuth
//import FirebaseFirestoreInternal

struct Report: Codable, Identifiable {
    @DocumentID var id: String?
    var title: String
    var description: String
    var issueType: String
    var timestamp: Date
    var latitude: Double       // 🧭 Needed for MapKit
    var longitude: Double      // 🧭 Needed for MapKit
    var status: String
    var userID: String // or use `var userEmail: String` if you prefer email

}

class ReportService {
    private let db = Firestore.firestore()

    func submitReport(_ report: Report, completion: @escaping (Error?) -> Void) {
        guard let user = Auth.auth().currentUser else {
            print("❌ No authenticated user found.")
            completion(NSError(domain: "auth", code: 401, userInfo: [NSLocalizedDescriptionKey: "User not logged in"]))
            return
        }

        var enrichedReport = report
        enrichedReport.userID = user.uid // 🧠 Use UID; or use `user.email`

        do {
            _ = try db.collection("Reports").addDocument(from: enrichedReport)
            completion(nil)
        } catch {
            completion(error)
        }
    }

    func fetchReports(completion: @escaping ([Report]) -> Void) {
        db.collection("Reports").order(by: "timestamp", descending: true).getDocuments { snapshot, error in
            if let error = error {
                print("Error fetching reports: \(error.localizedDescription)")
                completion([])
                return
            }

            let reports = snapshot?.documents.compactMap { doc in
                try? doc.data(as: Report.self)
            } ?? []

            completion(reports)
        }
    }
    // 🚀 TEST METHOD: Sends a dummy report to Firestore
//    func submitDummyReport() {
//        let testReport = Report(
//            title: "Broken Bench",
//            description: "Bench at Trinity Bellwoods is missing slats.",
//            timestamp: Date(),
//            latitude: 43.645,       // Toronto coords for example
//            longitude: -79.395,
//            status: "pending"
//        )
//
//        do {
//            _ = try db.collection("Reports").addDocument(from: testReport)
//            print("✅ Dummy report submitted!")
//        } catch {
//            print("❌ Error submitting dummy report: \(error.localizedDescription)")
//        }
//    }

}
