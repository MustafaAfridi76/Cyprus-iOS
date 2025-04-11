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

}
import CoreLocation

extension CLLocationCoordinate2D {
    func distance(to other: CLLocationCoordinate2D) -> CLLocationDistance {
        let loc1 = CLLocation(latitude: self.latitude, longitude: self.longitude)
        let loc2 = CLLocation(latitude: other.latitude, longitude: other.longitude)
        return loc1.distance(from: loc2)
    }
}

func titlesAreSimilar(_ title1: String, _ title2: String) -> Bool {
    let t1 = title1.lowercased()
    let t2 = title2.lowercased()
    return t1.contains(t2) || t2.contains(t1)
}

