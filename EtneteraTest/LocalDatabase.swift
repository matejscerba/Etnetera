//
//  LocalDatabase.swift
//  EtneteraTest
//
//  Created by Matěj Ščerba on 31.01.2022.
//

import Foundation
import CoreData

class LocalDatabase {
    static func loadWorkouts(for user: User, in context: NSManagedObjectContext) -> [Workout] {
        if let data = try? context.fetch(WorkoutData.fetchRequest()) {
            var workouts = [Workout]()
            for item in data {
                workouts.append(Workout(from: item))
            }
            return workouts
        }
        return [Workout]()
    }
    
    static func save(_ workout: Workout, for user: User, in context: NSManagedObjectContext, storage: Storage) -> Bool {
        let _ = WorkoutData(workout, context: context, storage: storage)
        do {
            try context.save()
        } catch {
            return false
        }
        return true
    }
    
    static func remove(_ workout: Workout, in context: NSManagedObjectContext) {
        if let data = try? context.fetch(WorkoutData.fetchRequest()) {
            for item in data {
                if item == workout {
                    context.delete(item)
                }
            }
            try? context.save()
        }
    }
}
