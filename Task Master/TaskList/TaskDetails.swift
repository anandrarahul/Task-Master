//
//  TaskDetails.swift
//  Task Master
//
//  Created by Rahul Anand on 03/08/24.
//

import Foundation

class TaskDetails {
    let taskTitle: String
    let taskDescription: String?
    let taskDeadline: String?
    
    init(title: String, description: String?, deadline: String?) {
        self.taskTitle = title
        self.taskDescription = description
        self.taskDeadline = deadline
    }
}
