//
//  ExamsVC.swift
//  StudentManagement-Assignment2
//
//  Created by Ziad on 10/22/20.
//  Copyright © 2020 intake4. All rights reserved.
//

import UIKit

class ExamsVC: UIViewController {
    
    var student: Student!
    var exams: [Exam]?
    @IBOutlet weak var segmentedControll: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var deleteBtn: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Setting some tableview staff
        setUpTableView()
        // Adding target to segmented controll when selected scope changes
        segmentedControll.addTarget(self, action: #selector(reloadTableView), for: .valueChanged)
        // Getting exams associated with current student
        fetchStudentExams()
    }
    
    func setUpTableView() {
        // Setting delegate and data source to self, delegation design pattern
        tableView.delegate = self
        tableView.dataSource = self
        // Registering custom cell
        tableView.register(ExamCell.nib(), forCellReuseIdentifier: ExamCell.identifier)
        // height for each row or cell
        tableView.rowHeight = 100
        // Creating long press gesture and adding it to tableview to handle multiple cells selection
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress))
        longPressGesture.minimumPressDuration = 1
        self.tableView.addGestureRecognizer(longPressGesture)
    }
    
    @objc func handleLongPress() {
        // Allowing multiple cell selection to remove them
        tableView.allowsMultipleSelectionDuringEditing = true
        // Activate tableview editing style
        tableView.isEditing = true
    }
    
    func fetchStudentExams() {
        // Getting exams if any
        CoreDataManager.shared.fetchExams(for: student) { [weak self] (exams, error) in
            guard exams != nil, error == nil else { return }
            self?.exams = exams
            // Reloading tableview in the main thread as it is UI update
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
    }
    
    @objc func reloadTableView() {
        // Reloading tableview in the main thread, as it is a UI update
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    @IBAction func newExamBtnPressed(_ sender: UIBarButtonItem) {
        // Creating new exam VC
        let newExamVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "ExamRecordVC") as! ExamRecordVC
        // Delegation design pattern
        newExamVC.examRecord = self
        // Presenting the controller
        newExamVC.modalPresentationStyle = .fullScreen
        present(newExamVC, animated: true)
    }
    
    @IBAction func closeBtnPressed(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    /// a func to filter array of exams depending on selected segmented scope and return the appropriate number of exams associated with current scope, either coming exam or past exam, in other words the func inserts the desired exams at the beginning of the array and returning the number of desired exams
    func numberOfExamsInSelectedSegmented() -> Int {
        // Accessing exams if any, otherwise return 0
        guard let exams = exams else { return 0 }
        // temp arr to make the work on
        var temporaryExamsArr: [Exam] = []
        // Number of exams associated with current scope
        var numOfExams = 0
        // Looping all exams
        for exam in exams {
            switch segmentedControll.selectedSegmentIndex {
            // Case 0 for Upcoming exams date
            case 0:
                // If exam date is Upcoming, or bigger than current date
                if exam.dateAndTime! > Date() {
                    // Inserting the exam at specific index
                    temporaryExamsArr.insert(exam, at: numOfExams)
                    numOfExams += 1
                } else {
                    // Exam date is past, so we will append the exam at the end of the array
                    temporaryExamsArr.append(exam)
                }
            // Default or case 1 for Past exams date
            default:
                // If exam date is past or smaller than current date
                if exam.dateAndTime! < Date() {
                    // Inserting the exam at specific index
                    temporaryExamsArr.insert(exam, at: numOfExams)
                    numOfExams += 1
                } else {
                    // Exam data is upcoming, so we will append the exam at the end of the array
                    temporaryExamsArr.append(exam)
                }
            }
        }
        // Passing exams from temporary array which we worked on to the tableview data source
        self.exams = temporaryExamsArr
        // Returning number of desired exams, depending on current segmented scope
        return numOfExams
    }
    
    @IBAction func deleteBtnPressed(_ sender: UIBarButtonItem) {
        // Accessing selected rows if any
        guard let selectedRows = tableView.indexPathsForSelectedRows else {
            // Otherwise presenting alert to inform user that there is no selected exams
            let noSelectionAlert = UIAlertController(title: "No exams selected", message: "Please select exam or more to delete", preferredStyle: .alert)
            noSelectionAlert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
            present(noSelectionAlert, animated: true)
            return
        }
        // Alert to make sure that user really wants to delete selected exams
        let deleteAlert = UIAlertController(title: "Delete exam", message: "Are you sure you want to delete selected exams?", preferredStyle: .actionSheet)
        deleteAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        deleteAlert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { [weak self] (action) in
            // Array to hold exams to remove
            var examsToDelete: [Exam] = []
            for indexPath in selectedRows {
                // Appending exams that user wants to remove in temporary array
                examsToDelete.append((self?.exams![indexPath.row])!)
            }
            // Looping on temporary array
            for examToDelete in examsToDelete {
                // Detecting index to remove at the original array
                if let index = self?.exams?.firstIndex(of: examToDelete) {
                    // Removing exam from original array or tableview data source
                    self?.exams?.remove(at: index)
                    // Removing exam from Core Data
                    self?.student.removeFromExams(examToDelete)
                    CoreDataManager.shared.saveStudent()
                }
            }
            // Reloading tableview in the main thread as it is UI update
            DispatchQueue.main.async {
                self?.tableView.reloadData()
                self?.tableView.isEditing = false
            }
        }))
        present(deleteAlert, animated: true)
    }
}

extension ExamsVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numberOfExamsInSelectedSegmented()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Creating and dequeue custom cell
        let cell = tableView.dequeueReusableCell(withIdentifier: ExamCell.identifier, for: indexPath) as! ExamCell
        // Configure cell component with exam object
        cell.configure(exams![indexPath.row])
        return cell
    }
     
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Deselect row if editing mode is not activated
        if !tableView.isEditing {
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        // Checking of no cells selected
        if tableView.indexPathsForSelectedRows == nil {
            // Closing tableview editing style
            tableView.isEditing = false
        }
    }
    
}

extension ExamsVC: ExamRecord {
    func newExam(_ exam: Exam) {
        // Appending new exam to our list of exams
        exams?.append(exam)
        // Reloading tableview in main thread as it is a UI update
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
        // Adding exam to student exams
        student?.addToExams(exam)
        // Saving changes to Core Data
        CoreDataManager.shared.saveStudent()
    }
}
