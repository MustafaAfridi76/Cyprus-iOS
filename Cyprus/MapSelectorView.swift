//
//  MapSelectorView.swift
//  Cyprus
//
//  Created by Mustafa Junaid on 28/03/2025.
//

import MapKit
import SwiftUI

struct IdentifiableCoordinate: Identifiable {
    let id = UUID()
    var coordinate: CLLocationCoordinate2D
}

struct MapSelectorView: View {
    @Binding var selectedCoordinate: CLLocationCoordinate2D
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 43.65774, longitude: -79.38080), // Default: Toronto
        span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        
    )
    

    var body: some View {
        Map(coordinateRegion: $region,
            interactionModes: .all,
            annotationItems: [IdentifiableCoordinate(coordinate: selectedCoordinate)]) { item in
            MapMarker(coordinate: item.coordinate, tint: .red)
        }
        .onTapGesture {
            let mapPoint = region.center
            selectedCoordinate = mapPoint
        }
        .frame(height: 400)
        .cornerRadius(12)
//        .padding(.horizontal)
    }
}
