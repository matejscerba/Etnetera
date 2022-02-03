//
//  WorkoutData+CoreDataClass.swift
//  EtneteraTest
//
//  Created by Matěj Ščerba on 01.02.2022.
//
//

import Foundation
import CoreData


public class WorkoutData: NSManagedObject {
    convenience init(_ workout: Workout, context: NSManagedObjectContext, storage: Storage) {
        self.init(context: context)
        self.timestamp = workout.timestamp
        self.title = workout.title
        self.location = workout.location
        if let coords = workout.coordinates {
            self.latitude = coords.latitude
            self.longitude = coords.longitude
            self.coordinates = true
        } else {
            self.latitude = 0
            self.longitude = 0
            self.coordinates = false
        }
        self.duration = Int64(((workout.hours * 60) + workout.minutes) * 60 + workout.seconds)
        self.remote = storage == .remote
    }
}
