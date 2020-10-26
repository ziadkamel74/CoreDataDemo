//
//  Exam+CoreDataClass.swift
//  StudentManagement-Assignment2
//
//  Created by Ziad on 10/25/20.
//  Copyright © 2020 intake4. All rights reserved.
//
//

import Foundation
import CoreData

@objc(Exam)
public class Exam: NSManagedObject {
    // Calling the designated initializer and setting instance values
    convenience init(name: String, dateAndTime: Date, location: String, context: NSManagedObjectContext) {
        self.init(context: context)
        self.name = name
        self.dateAndTime = dateAndTime
        self.location = location
    }
}
