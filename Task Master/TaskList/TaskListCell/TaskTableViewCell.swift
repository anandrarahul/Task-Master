//
//  TaskTableViewCell.swift
//  Task Master
//
//  Created by Rahul Anand on 28/07/24.
//

import UIKit

protocol SaveDetailsDelegate: NSObject {
    func updateTaskDetails()
}

class TaskTableViewCell: UITableViewCell {

    @IBOutlet weak var taskDescription: UILabel!
    @IBOutlet weak var taskTitle: UILabel!
    @IBOutlet weak var selectionStatusButton: UIButton!
    @IBOutlet weak var taskDeadline: UILabel!
    
    var taskDetails: TaskDetails?
    weak var delegate: SaveDetailsDelegate?
    
    @IBAction func selectionButtonTapped(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        let taskState = sender.isSelected ? "Done" : "To Do"
        let imageName = sender.isSelected ? "selected" : "unselected"
        self.selectionStatusButton.setImage(UIImage(named: imageName), for: .normal)
        TaskMasterCoreDataManager.shared.updateTask(taskDetails: self.taskDetails!, title: self.taskTitle.text, description: self.taskDescription.text, status: taskState, deadline: self.taskDeadline.text)
        self.delegate?.updateTaskDetails()
    }
    
    func setTaskDetails(taskDetails: TaskDetails) {
        self.taskTitle.text = taskDetails.taskTitle
        self.taskDescription.text = taskDetails.taskDescription ?? ""
        self.taskDeadline.text = taskDetails.taskDeadline ?? ""
        if taskDetails.taskStatus == "Done" {
            self.selectionStatusButton.setImage(UIImage(named: "selected"), for: .normal)
            self.selectionStatusButton.isSelected = true
        } else if taskDetails.taskStatus == "To Do" {
            self.selectionStatusButton.setImage(UIImage(named: "unselected"), for: .normal)
            self.selectionStatusButton.isSelected = false
        }
        self.taskDetails = taskDetails
    }
    
}
