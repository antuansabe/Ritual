//
//  WorkoutEntity+CoreDataProperties.swift
//  
//
//  Created by Antonio Dromundo on 05/07/25.
//
//  This file was automatically generated and should not be edited.
//

import Foundation
import CoreData


extension WorkoutEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<WorkoutEntity> {
        return NSFetchRequest<WorkoutEntity>(entityName: "WorkoutEntity")
    }

    @NSManaged public var calories: Int32
    @NSManaged public var date: Date?
    @NSManaged public var duration: Int32
    @NSManaged public var id: UUID?
    @NSManaged public var type: String?

}

extension WorkoutEntity : Identifiable {

}
