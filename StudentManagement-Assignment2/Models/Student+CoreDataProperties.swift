//
//  Student+CoreDataProperties.swift
//  StudentManagement-Assignment2
//
//  Created by Ziad on 10/25/20.
//  Copyright © 2020 intake4. All rights reserved.
//
//

import Foundation
import CoreData


extension Student {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Student> {
        return NSFetchRequest<Student>(entityName: "Student")
    }

    @NSManaged public var address: String?
    @NSManaged public var age: Int64
    @NSManaged public var courseStudy: String?
    @NSManaged public var firstName: String?
    @NSManaged public var gender: String?
    @NSManaged public var id: Int64
    @NSManaged public var lastName: String?
    @NSManaged public var imageData: Data?
    @NSManaged public var exams: NSSet?

}

// MARK: Generated accessors for exams
extension Student {

    @objc(addExamsObject:)
    @NSManaged public func addToExams(_ value: Exam)

    @objc(removeExamsObject:)
    @NSManaged public func removeFromExams(_ value: Exam)

    @objc(addExams:)
    @NSManaged public func addToExams(_ values: NSSet)

    @objc(removeExams:)
    @NSManaged public func removeFromExams(_ values: NSSet)

}
