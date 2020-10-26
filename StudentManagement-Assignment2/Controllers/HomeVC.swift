//
//  ViewController.swift
//  StudentManagement-Assignment2
//
//  Created by Ziad on 10/19/20.
//  Copyright © 2020 intake4. All rights reserved.
//

import UIKit

class HomeVC: UIViewController {
    
    // Data of the table
    var students: [Student] = []

    @IBOutlet weak var tableView: UITableView!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Get students from Core Data
        fetchStudents()
    }
    
    func fetchStudents() {
        // Fetch the data from Core Data to display in tableview
        CoreDataManager.shared.fetchStudents { [weak self] (students, error) in
            // Safe unwrapping data
            guard let students = students, error == nil else {
                // Print error if any
                print(error!)
                return
            }
            self?.students = students
            // Reloading table view in the main thread
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
    }

    @IBAction func newStudentBtnPressed(_ sender: UIBarButtonItem) {
        // Creating the recored screen
        let newRecordVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "StudentRecordVC") as! StudentRecordVC
        // Presenting the record screen
        newRecordVC.modalPresentationStyle = .fullScreen
        present(newRecordVC, animated: true)
    }
    
}


extension HomeVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Returning the count of students we have
        return students.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Creating and dequeuing the cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "StudentCell", for: indexPath)
        // Displaying student name in the cell text label
        cell.textLabel?.text = "\(students[indexPath.row].firstName!) \(students[indexPath.row].lastName!)"
        // Displaying student id in the cell detail text label
        cell.detailTextLabel?.text = "\(students[indexPath.row].id)"
        // Displaying the student cell
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Animated deselection when touches the cell
        tableView.deselectRow(at: indexPath, animated: true)
        // Student to Show and Edit
        let student = students[indexPath.row]
        // Creating the record controller
        let showAndEditRecordVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "StudentRecordVC") as! StudentRecordVC
        // Pass the student to record controller
        showAndEditRecordVC.studentToShowAndEdit = student
        // Presenting the record controller
        showAndEditRecordVC.modalPresentationStyle = .fullScreen
        present(showAndEditRecordVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        // Creating swipe action
        let action = UIContextualAction(style: .destructive, title: "Delete") { [weak self] (action, view, completionHandler) in
            // Which student to remove
            guard let student = self?.students[indexPath.row] else { return }
            // Remove from Core Data
            CoreDataManager.shared.remove(student) { (removed) in
                // If removed fetch new data
                if removed {
                    self?.fetchStudents()
                }
            }
        }
        return UISwipeActionsConfiguration(actions: [action])
    }
}
