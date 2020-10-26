//
//  ExamRecordVC.swift
//  StudentManagement-Assignment2
//
//  Created by Ziad on 10/23/20.
//  Copyright © 2020 intake4. All rights reserved.
//

import UIKit

/// Protocol to pass exam back
protocol ExamRecord {
    func newExam(_ exam: Exam)
}

class ExamRecordVC: UIViewController {
    
    @IBOutlet weak var examNameTextField: UITextField!
    @IBOutlet weak var examLocationTextField: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    // Instance from protocol to pass exam in
    var examRecord: ExamRecord?

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func saveBtnPressed(_ sender: UIBarButtonItem) {
        if isValidExamData() {
            saveExam()
        }
    }
    
    @IBAction func cancelBtnPressed(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    func isValidExamData() -> Bool {
        if let examName = examNameTextField.text, !examName.isEmpty, let examLocation = examLocationTextField.text, !examLocation.isEmpty {
            return true
        }
        let alert = UIAlertController(title: "Missed Data", message: "Please enter all exam data", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
        present(alert, animated: true)
        return false
    }
    
    func saveExam() {
        // Creating the exam
        let exam = Exam(name: examNameTextField.text!, dateAndTime: datePicker.date, location: examLocationTextField.text!, context: CoreDataManager.shared.managedContext)
        // Passing exam to previous VC
        examRecord?.newExam(exam)
        // Closing the VC
        dismiss(animated: true, completion: nil)
    }
    
}
