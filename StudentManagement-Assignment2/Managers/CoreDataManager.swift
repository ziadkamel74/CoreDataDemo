//
//  CoreDataManager.swift
//  StudentManagement-Assignment2
//
//  Created by Ziad on 10/20/20.
//  Copyright © 2020 intake4. All rights reserved.
//

import UIKit
import CoreData

class CoreDataManager {
    // Shared instance, singleton design pattern
    static let shared = CoreDataManager()
    
    // Reference to managed object context
    let managedContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    func fetchStudents(completion: @escaping ([Student]?, Error?) -> Void) {
        // Fetch the data from Core Data to display in tableview
        do {
            completion(try managedContext.fetch(Student.fetchRequest()), nil)
        } catch {
            completion(nil, error)
        }
    }
    
    func fetchExams(for student: Student, completion: ([Exam]?, Error?) -> Void) {
        // Reference to the fetch request
        let request = Exam.fetchRequest() as NSFetchRequest<Exam>
        // set the feltering on the exams
        let pred = NSPredicate(format: "student = %@", student)
        request.predicate = pred
        do {
            completion(try managedContext.fetch(request), nil)
        } catch {
            completion(nil, error)
        }
    }
    
    func saveStudent() {
        do {
            // Saving student
            try managedContext.save()
        } catch {
            // Catching error if any
            print(error)
        }
    }
    
    func remove(_ student: Student, completion: (Bool) -> Void) {
        // Remove the student
        self.managedContext.delete(student)
        do {
            // Save the data
            try managedContext.save()
            completion(true)
        } catch {
            // Print error if any
            print(error)
            completion(false)
        }
    }
}
