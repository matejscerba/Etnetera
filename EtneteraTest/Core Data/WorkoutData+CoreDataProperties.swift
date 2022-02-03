//
//  WorkoutData+CoreDataProperties.swift
//  EtneteraTest
//
//  Created by Matěj Ščerba on 03.02.2022.
//
//

import Foundation
import CoreData


extension WorkoutData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<WorkoutData> {
        return NSFetchRequest<WorkoutData>(entityName: "WorkoutData")
    }

    @NSManaged public var duration: Int64
    @NSManaged public var location: String
    @NSManaged public var remote: Bool
    @NSManaged public var timestamp: Date
    @NSManaged public var title: String
    @NSManaged public var latitude: Double
    @NSManaged public var longitude: Double
    @NSManaged public var coordinates: Bool

}

extension WorkoutData : Identifiable {

}
