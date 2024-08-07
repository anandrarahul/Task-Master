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
        if let deadline = self.taskDeadline.text, deadline != "" {
            if let timeInterval = self.timeIntervalBetweenCurrentDateAnd(dateString: deadline), timeInterval > 0 {
                let bufferTime: Double = 60 * 60 * 14; //60 seconds * 60 minutes * 14 for 14 hours. So, that the notification will be send at 10 am one day before.
                LocalNotificationManager.shared.scheduleNotification(title: self.taskTitle.text!, body: self.taskDescription.text!, timeInterval: timeInterval - bufferTime)
//                LocalNotificationManager.shared.scheduleNotification(title: self.taskTitle.text!, body: self.taskDescription.text!, timeInterval: timeInterval - 43350)
//                print(timeInterval - 43350)
            }
        }
    }
    
    func timeIntervalBetweenCurrentDateAnd(dateString: String, dateFormat: String = "dd-MM-yyyy") -> TimeInterval? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        guard let targetDate = dateFormatter.date(from: dateString) else {
            print("Invalid date format or date string")
            return nil
        }
        let currentDate = Date()
        let timeInterval = targetDate.timeIntervalSince(currentDate)
        return timeInterval
    }
    
}
