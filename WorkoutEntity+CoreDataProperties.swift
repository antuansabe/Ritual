//
//  WorkoutEntity+CoreDataProperties.swift
//  fit-app
//
//  Created by Antonio Dromundo on 02/07/25.
//
//

import Foundation
import CoreData


extension WorkoutEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<WorkoutEntity> {
        return NSFetchRequest<WorkoutEntity>(entityName: "WorkoutEntity")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var date: Date?
    @NSManaged public var duration: Int32
    @NSManaged public var calories: Int32
    @NSManaged public var type: String?

}

extension WorkoutEntity : Identifiable {

}
