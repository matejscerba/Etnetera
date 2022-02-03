//
//  User.swift
//  EtneteraTest
//
//  Created by Matěj Ščerba on 31.01.2022.
//

import Foundation
import SwiftUI
import FirebaseAuth

class User: ObservableObject {
    private var context = PersistenceController.shared.container.viewContext

    static var shared = User()

    @Published var workouts = [Workout]()
    private(set) var id: String?
    
    private init() {
        reload()
    }
    
    func reload() {
        for workout in LocalDatabase.loadWorkouts(for: self, in: context) {
            if !workouts.contains(where: { $0 == workout }) {
                workouts.append(workout)
            }
        }
        Auth.auth().signInAnonymously { [weak self] result, error in
            if let user = result?.user {
                self?.id = user.uid
                self?.loadRemoteWorkouts()
            }
        }
    }
    
    private func loadRemoteWorkouts() {
        RemoteDatabase.loadWorkouts(for: self) { [weak self] workouts in
            if let self = self {
                var toRemove = [Workout]()
                for workout in workouts {
                    if let local = self.workouts.first(where: { $0 == workout }) {
                        toRemove.append(local)
                    }
                }
                // Remove workouts loaded from remote storage, that are already in local storage.
                self.workouts.removeAll(where: { toRemove.contains($0) })
                for element in toRemove {
                    LocalDatabase.remove(element, in: self.context)
                }
                self.workouts.append(contentsOf: workouts)
            }
        }
    }
    
    func addWorkout(title: String, location: String, latitude: Double?, longitude: Double?, hours: Int, minutes: Int, seconds: Int, storage: Storage) -> Bool {
        let workout = Workout(title: title, location: location, latitude: latitude, longitude: longitude, hours: hours, minutes: minutes, seconds: seconds, timestamp: Date(), storage: storage)
        workouts.append(workout)
        switch storage {
        case .local:
            return LocalDatabase.save(workout, for: self, in: context, storage: .local)
        case .remote:
            if LocalDatabase.save(workout, for: self, in: context, storage: .remote) {
                RemoteDatabase.save(workout, for: self) { [weak self] result in
                    if let self = self, result {
                        LocalDatabase.remove(workout, in: self.context)
                    }
                }
                return true
            } else {
                return false
            }
        default:
            return false
        }
    }
    
    func deleteWorkout(_ workout: Workout) {
        switch workout.storage {
        case .local:
            LocalDatabase.remove(workout, in: context)
        case .remote:
            LocalDatabase.remove(workout, in: context)
            RemoteDatabase.remove(workout, for: self)
        case .all:
            break
        }
        workouts.removeAll(where: { $0 == workout })
    }
}

extension Array where Element == Workout {
    func filtered(storage: Storage) -> [Workout] {
        let result: [Workout]
        if storage == .all {
            result = self
        } else {
            result = self.filter({ $0.storage == storage })
        }
        return result.sorted { lhs, rhs in
            lhs.timestamp > rhs.timestamp
        }
    }
}

extension User {
    static var sample = User(workouts: [
        Workout(title: "XC skiing", location: "Home", latitude: nil, longitude: nil, hours: 3, minutes: 24, seconds: 5, timestamp: Date().addingTimeInterval(-10), storage: .local),
        Workout(title: "Run", location: "Track", latitude: nil, longitude: nil, hours: 1, minutes: 5, seconds: 1, timestamp: Date(), storage: .local),
        Workout(title: "Run", location: "Track", latitude: -3, longitude: 26, hours: 1, minutes: 5, seconds: 1, timestamp: Date(), storage: .local),
        Workout(title: "Run", location: "Track", latitude: nil, longitude: nil, hours: 1, minutes: 5, seconds: 1, timestamp: Date(), storage: .local),
        Workout(title: "Run", location: "Track", latitude: 10, longitude: 100, hours: 1, minutes: 5, seconds: 1, timestamp: Date(), storage: .local),
        Workout(title: "Run", location: "Track", latitude: nil, longitude: nil, hours: 1, minutes: 5, seconds: 1, timestamp: Date(), storage: .local),
        Workout(title: "Run", location: "Track", latitude: 0, longitude: 0, hours: 1, minutes: 5, seconds: 1, timestamp: Date(), storage: .local),
        Workout(title: "Run", location: "Track", latitude: nil, longitude: nil, hours: 1, minutes: 5, seconds: 1, timestamp: Date(), storage: .local),
        Workout(title: "Run", location: "Track", latitude: nil, longitude: nil, hours: 1, minutes: 5, seconds: 1, timestamp: Date(), storage: .local),
        Workout(title: "Run", location: "Track", latitude: nil, longitude: nil, hours: 1, minutes: 5, seconds: 1, timestamp: Date(), storage: .local),
        Workout(title: "Run", location: "Track", latitude: 25.5, longitude: -0.2654, hours: 1, minutes: 5, seconds: 1, timestamp: Date(), storage: .local),
        Workout(title: "Bike", location: "Mountains", latitude: nil, longitude: nil, hours: 2, minutes: 59, seconds: 54, timestamp: Date().addingTimeInterval(10), storage: .remote)
    ])
    
    private convenience init(workouts: [Workout]) {
        self.init()
        self.workouts = workouts
    }
}
