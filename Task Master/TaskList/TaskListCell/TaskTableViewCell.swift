//
//  TaskTableViewCell.swift
//  Task Master
//
//  Created by Rahul Anand on 28/07/24.
//

import UIKit

class TaskTableViewCell: UITableViewCell {

    @IBOutlet weak var taskDescription: UILabel!
    @IBOutlet weak var taskTitle: UILabel!
    @IBOutlet weak var selectionStatusButton: UIButton!
    weak var delegate: SaveDetailsDelegate?
    
    @IBAction func selectionButtonTapped(_ sender: UIButton) {
        var taskState: TaskListStatus
        if sender.isSelected == true {
            self.selectionStatusButton.setImage(UIImage(named: "unselected"), for: .normal)
            taskState = .toDo
        } else {
            self.selectionStatusButton.setImage(UIImage(named: "selected"), for: .normal)
            taskState = .done
        }
        sender.isSelected = !sender.isSelected
        self.delegate?.updateTaskDetails(taskDetail: TaskDetails(title: self.taskTitle.text!, description: self.taskDescription.text, deadline: "soon"), taskStatus: taskState)
    }
    override func awakeFromNib() {
        super.awakeFromNib()
//        self.selectionStatusButton.setImage(UIImage(named: "unselected"), for: .normal)
//        self.selectionStatusButton.isSelected = false
    }
    
    func setTaskDetails(taskDetails: TaskDetails, taskStatus: TaskListStatus) {
        self.taskTitle.text = taskDetails.taskTitle
        self.taskDescription.text = taskDetails.taskDescription ?? ""
        if taskStatus == .done {
            self.selectionStatusButton.setImage(UIImage(named: "selected"), for: .normal)
            self.selectionStatusButton.isSelected = true
        } else if taskStatus == .toDo {
            self.selectionStatusButton.setImage(UIImage(named: "unselected"), for: .normal)
            self.selectionStatusButton.isSelected = false
        }
    }
    
}
