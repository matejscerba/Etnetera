//
//  ShowMapView.swift
//  EtneteraTest
//
//  Created by Matěj Ščerba on 03.02.2022.
//

import SwiftUI
import MapKit

struct ShowMapView: View {
    var workout: Workout
    @State private var region: MKCoordinateRegion
    
    var body: some View {
        Map(coordinateRegion: $region, annotationItems: [workout]) { item in
            MapMarker(coordinate: item.coordinates!)
        }
        .edgesIgnoringSafeArea([.leading, .trailing, .bottom])
        .navigationTitle("\(workout.title), \(workout.location)")
    }

    init(workout: Workout) {
        self.workout = workout
        self._region = State(initialValue: MKCoordinateRegion(center: workout.coordinates!, latitudinalMeters: 3000, longitudinalMeters: 3000))
    }
}

struct ShowMapView_Previews: PreviewProvider {
    static var previews: some View {
        ShowMapView(workout: Workout(dbID: nil, title: "Run", location: "Home", latitude: 10, longitude: 100, hours: 1, minutes: 3, seconds: 5, timestamp: Date(), storage: .local))
    }
}
