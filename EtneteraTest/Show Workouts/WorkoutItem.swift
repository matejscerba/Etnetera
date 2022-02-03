//
//  WorkoutItem.swift
//  EtneteraTest
//
//  Created by Matěj Ščerba on 01.02.2022.
//

import SwiftUI

struct WorkoutItem: View {
    var workout: Workout
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(workout.title)
                    .font(.headline)
                Spacer()
                Text(workout.location)
                    .font(.caption)
            }
            Spacer()
            VStack(alignment: .trailing) {
                Text("\(workout.hours):\(String(format: "%02d", workout.minutes)):\(String(format: "%02d", workout.seconds))")
                    .font(.body)
                Spacer()
                Text(workout.timestamp.formatted(date: .abbreviated, time: .omitted))
            }
        }
        .padding()
    }
    
}

struct WorkoutItem_Preview: PreviewProvider {
    static var previews: some View {
        WorkoutItem(workout: Workout(title: "Run", location: "Home", latitude: nil, longitude: nil, hours: 1, minutes: 31, seconds: 42, timestamp: Date(), storage: .local))
            .previewLayout(.fixed(width: 400, height: 100))
    }
}
