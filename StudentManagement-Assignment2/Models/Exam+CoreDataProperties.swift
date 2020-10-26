//
//  Exam+CoreDataProperties.swift
//  StudentManagement-Assignment2
//
//  Created by Ziad on 10/25/20.
//  Copyright © 2020 intake4. All rights reserved.
//
//

import Foundation
import CoreData


extension Exam {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Exam> {
        return NSFetchRequest<Exam>(entityName: "Exam")
    }

    @NSManaged public var dateAndTime: Date?
    @NSManaged public var location: String?
    @NSManaged public var name: String?
    @NSManaged public var student: Student?

}
