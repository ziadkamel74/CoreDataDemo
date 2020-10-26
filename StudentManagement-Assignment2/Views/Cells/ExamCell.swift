//
//  ExamCell.swift
//  StudentManagement-Assignment2
//
//  Created by Ziad on 10/24/20.
//  Copyright © 2020 intake4. All rights reserved.
//

import UIKit

class ExamCell: UITableViewCell {
    
    // Cell identifier
    static let identifier = "ExamCell"
    
    @IBOutlet weak var examNameLabel: UILabel!
    @IBOutlet weak var examDateLabel: UILabel!
    @IBOutlet weak var examLocationLabel: UILabel!
    
    static func nib() -> UINib {
        // Return nib file associated with exam cell
        return UINib(nibName: "ExamCell", bundle: nil)
    }

    func configure(_ exam: Exam) {
        // Setting exam name to name label
        examNameLabel.text = exam.name
        // instance from date formatter to edit exam date format
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .short
        dateFormatter.timeZone = .none
        // Setting formatted date into date label as string
        examDateLabel.text = dateFormatter.string(from: exam.dateAndTime!)
        // Setting exam location to location label
        examLocationLabel.text = exam.location
    }
    
}
