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
    
    @IBAction func selectionButtonTapped(_ sender: UIButton) {
        if sender.isSelected == true {
            self.selectionStatusButton.setImage(UIImage(named: "unselected"), for: .normal)
        } else {
            self.selectionStatusButton.setImage(UIImage(named: "selected"), for: .normal)
        }
        sender.isSelected = !sender.isSelected
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStatusButton.setImage(UIImage(named: "unselected"), for: .normal)
        self.selectionStatusButton.isSelected = false
    }
    
    func setTaskDetails(title: String, desc: String, taskImage: String? = nil) {
        self.taskTitle.text = title
        self.taskDescription.text = desc
    }
    
}
