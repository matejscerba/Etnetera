//
//  Workout.swift
//  EtneteraTest
//
//  Created by Matěj Ščerba on 31.01.2022.
//

import Foundation
import CoreLocation

struct Workout: Identifiable {
    private(set) var dbID: String?
    private(set) var title: String
    private(set) var location: String
    private(set) var coordinates: CLLocationCoordinate2D?
    private(set) var hours: Int
    private(set) var minutes: Int
    private(set) var seconds: Int
    private(set) var timestamp: Date
    private(set) var storage: Storage

    var id: Date { timestamp }
    
    init(dbID: String? = nil, title: String, location: String, latitude: Double?, longitude: Double?, hours: Int, minutes: Int, seconds: Int, timestamp: Date, storage: Storage) {
        self.dbID = dbID
        self.title = title
        self.location = location
        if let lat = latitude, let lon = longitude {
            self.coordinates = CLLocationCoordinate2D(latitude: lat, longitude: lon)
        } else {
            self.coordinates = nil
        }
        self.hours = hours
        self.minutes = minutes
        self.seconds = seconds
        self.timestamp = timestamp
        self.storage = storage
    }

    init(from data: WorkoutData) {
        self.title = data.title
        self.location = data.location
        if data.coordinates {
            self.coordinates = CLLocationCoordinate2D(latitude: data.latitude, longitude: data.longitude)
        } else {
            self.coordinates = nil
        }
        self.hours = Int((data.duration / 60) / 60)
        self.minutes = Int((data.duration / 60) % 60)
        self.seconds = Int(data.duration % 60)
        self.timestamp = data.timestamp
        if data.remote {
            self.storage = .remote
        } else {
            self.storage = .local
        }
    }
}

extension Workout: Equatable {
    static func == (lhs: Workout, rhs: Workout) -> Bool {
        return abs(
            lhs.timestamp.timeIntervalSince1970 - rhs.timestamp.timeIntervalSince1970
        ) < 1
    }
    
    static func == (lhs: WorkoutData, rhs: Workout) -> Bool {
        return abs(
            lhs.timestamp.timeIntervalSince1970 - rhs.timestamp.timeIntervalSince1970
        ) < 1
    }
}
