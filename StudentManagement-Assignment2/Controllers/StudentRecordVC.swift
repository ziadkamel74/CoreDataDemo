//
//  StudentRecordVC.swift
//  StudentManagement-Assignment2
//
//  Created by Ziad on 10/19/20.
//  Copyright © 2020 intake4. All rights reserved.
//

import UIKit

class StudentRecordVC: UIViewController {
        
    @IBOutlet weak var studentImageBtn: UIButton!
    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var genderSwitch: UISwitch!
    @IBOutlet weak var courseStudyTextField: UITextField!
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var ageStepper: UIStepper!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var examsBtn: UIButton!
    
    // Student to Show and Edit
    var studentToShowAndEdit: Student?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setting the student unique id to the label, no one can edit it
        idLabel.text = "\(UUID().hashValue)"
        
        studentImageBtn.addTarget(self, action: #selector(presentImagePicker), for: .touchUpInside)
        ageStepper.addTarget(self, action: #selector(updateAgeLabel), for: .valueChanged)
        examsBtn.addTarget(self, action: #selector(didTapExamsBtn), for: .touchUpInside)
        
        // Check if there a student to show its info and enable editing
        showStudentInfo()
    }
    
    @objc func presentImagePicker() {
        // Picker instance
        let picker = UIImagePickerController()
        // Allow image cropping
        picker.allowsEditing = true
        // Setting delegate to self, delegation design pattern require conforming protocols
        picker.delegate = self
        // Presenting the image picker
        self.present(picker, animated: true, completion: nil)
    }
    
    func showStudentInfo() {
        // Button Circular view student image
        studentImageBtn.layer.cornerRadius = studentImageBtn.frame.width / 2
        studentImageBtn.layer.masksToBounds = true
        // Check if we have student to show and enable editing
        guard let studentToShowAndEdit = studentToShowAndEdit else {
            // If there is no student, we need to hide exams button
            examsBtn.isHidden = true
            return
        }
            // Setting student info
        idLabel.text = String(describing: studentToShowAndEdit.id)
        if let imageData = studentToShowAndEdit.imageData {
            studentImageBtn.setImage(UIImage(data: imageData), for: .normal)
        }
        firstNameTextField.text = studentToShowAndEdit.firstName
        lastNameTextField.text = studentToShowAndEdit.lastName
        courseStudyTextField.text = studentToShowAndEdit.courseStudy
        addressTextField.text = studentToShowAndEdit.address
        ageLabel.text = String(describing: studentToShowAndEdit.age)
            // Setting gender switch to on if female
        if studentToShowAndEdit.gender == Gender.female.rawValue {
                genderSwitch.isOn = true
            }
        // Updating age stepper value
        ageStepper.value = Double(integerLiteral: studentToShowAndEdit.age)
    }
    
    @IBAction func saveBtnPressed(_ sender: UIBarButtonItem) {
        if isValidData() {
            saveStudent()
            dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func cancelBtnPressed(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    func checkGender() -> String {
        // Returning gender rawValue as String
        if genderSwitch.isOn {
            return Gender.female.rawValue
        } else {
            return Gender.male.rawValue
        }
    }
    
    @objc func updateAgeLabel() {
        // Setting the value in the age label from the stepper
        ageLabel.text = "\(Int(exactly: ageStepper.value)!)"
    }
    
    func isValidData() -> Bool {
        // Checking inserted data, if all good return true
        if let firstName = firstNameTextField.text, !firstName.isEmpty, let lastName = lastNameTextField.text, !lastName.isEmpty, let courseStudy = courseStudyTextField.text, !courseStudy.isEmpty, let address = addressTextField.text, !address.isEmpty, let _ = Int(ageLabel.text!) {
            return true
        }
        // Informing user that there is missed data and return false
        let alert = UIAlertController(title: "Missed Data", message: "Please enter all data above", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
        present(alert, animated: true)
        return false
    }
    
    func saveStudent() {
        // Checking if there is student to Edit
        switch studentToShowAndEdit != nil {
        case false:
            //There is no student to edit, so we will create new Student
            let _ = Student(id: Int64(idLabel.text!)!, imageData: (studentImageBtn.currentImage?.jpegData(compressionQuality: 0.8)) ?? nil, firstName: firstNameTextField.text!, lastName: lastNameTextField.text!, gender: checkGender(), courseStudy: courseStudyTextField.text!, age: Int64(ageLabel.text!)!, address: addressTextField.text!, context: CoreDataManager.shared.managedContext)
        case true:
            // There is student to edit, so we will make the changes if any
            studentToShowAndEdit?.firstName = firstNameTextField.text
            studentToShowAndEdit?.lastName = lastNameTextField.text
            studentToShowAndEdit?.gender = checkGender()
            studentToShowAndEdit?.courseStudy = courseStudyTextField.text
            studentToShowAndEdit?.age = Int64(ageLabel.text!)!
            studentToShowAndEdit?.address = addressTextField.text
            studentToShowAndEdit?.imageData = studentImageBtn.currentImage?.jpegData(compressionQuality: 0.8)
        }
        // Saving student to Core Data
        CoreDataManager.shared.saveStudent()
    }
    
    @objc func didTapExamsBtn() {
        // Create Exams controller
        let examsVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "ExamsVC") as! ExamsVC
        // Passing the student
        examsVC.student = studentToShowAndEdit
        // Present VC
        examsVC.modalPresentationStyle = .fullScreen
        present(examsVC, animated: true)
    }
    
}

extension StudentRecordVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else { return }
        studentImageBtn.setImage(image, for: .normal)
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        // Dismiss picker when user cancel
        picker.dismiss(animated: true, completion: nil)
    }
}
