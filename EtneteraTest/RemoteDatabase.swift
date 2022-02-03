//
//  RemoteDatabase.swift
//  EtneteraTest
//
//  Created by Matěj Ščerba on 31.01.2022.
//

import Foundation
import FirebaseFirestore

class RemoteDatabase {
    private static let db = Firestore.firestore()
    
    static func loadWorkouts(for user: User, completion: @escaping ([Workout]) -> Void) {
        if let id = user.id {
            db.collection("users").document(id).collection("workouts").getDocuments { querySnapshot, error in
                var result = [Workout]()
                if let snapshot = querySnapshot {
                    for document in snapshot.documents {
                        if let workout = getWorkout(dbID: document.documentID, from: document.data()) {
                            result.append(workout)
                        }
                    }
                }
                completion(result)
            }
        }
    }

    static func save(_ workout: Workout, for user: User, completion: @escaping (Bool) -> Void) {
        if let id = user.id {
            db.collection("users").document(id).collection("workouts").addDocument(data: getData(of: workout)) { error in
                completion(error == nil)
            }
        }
    }
    
    static func remove(_ workout: Workout, for user: User) {
        if let id = user.id, let dbID = workout.dbID {
            db.collection("users").document(id).collection("workouts").document(dbID).delete()
        }
    }
    
    // MARK: - Data conversion

    private static func getData(of workout: Workout) -> [String:Any] {
        var result: [String:Any] = [
            "title" : workout.title,
            "location" : workout.location,
            "duration" : ((workout.hours * 60) + workout.minutes) * 60 + workout.seconds,
            "timestamp" : Timestamp(date: workout.timestamp)
        ]
        if let coords = workout.coordinates {
            result["latitude"] = coords.latitude
            result["longitude"] = coords.longitude
        }
        return result
    }
    
    private static func getWorkout(dbID: String, from data: [String:Any]) -> Workout? {
        guard let title = data["title"] as? String else { return nil }
        guard let location = data["location"] as? String else { return nil }
        let latitude = data["latitude"] as? Double
        let longitude = data["longitude"] as? Double
        guard let duration = data["duration"] as? Int else { return nil }
        guard let timestamp = data["timestamp"] as? Timestamp else { return nil }
        let hours = (duration / 60) / 60
        let minutes = (duration / 60) % 60
        let seconds = duration % 60
        return Workout(dbID: dbID, title: title, location: location, latitude: latitude, longitude: longitude, hours: hours, minutes: minutes, seconds: seconds, timestamp: timestamp.dateValue(), storage: .remote)
    }
    
}
