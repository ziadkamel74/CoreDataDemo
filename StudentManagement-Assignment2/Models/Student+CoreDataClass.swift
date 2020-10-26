//
//  Student+CoreDataClass.swift
//  StudentManagement-Assignment2
//
//  Created by Ziad on 10/25/20.
//  Copyright © 2020 intake4. All rights reserved.
//
//

import Foundation
import CoreData


// Enum for specific types of gender
enum Gender: String {
    case male, female
}

@objc(Student)
public class Student: NSManagedObject {
    // Calling the designated initializer and setting instance values
    convenience init(id: Int64, imageData: Data?, firstName: String, lastName: String, gender: String, courseStudy: String, age: Int64, address: String, context: NSManagedObjectContext) {
        self.init(context: context)
        self.id = id
        self.imageData = imageData
        self.firstName = firstName
        self.lastName = lastName
        self.gender = gender
        self.courseStudy = courseStudy
        self.age = age
        self.address = address
    }
}
