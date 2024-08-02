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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStatusButton.imageView?.image = UIImage(named: "unselected")
    }
    
    func setTaskDetails(title: String, desc: String, taskImage: String? = nil) {
        self.taskTitle.text = title
        self.taskDescription.text = desc
    }
    
}
