//
//  TaskDetails.swift
//  Task Master
//
//  Created by Rahul Anand on 03/08/24.
//

import Foundation

class TaskDetails {
    let title: String
    let description: String?
    let deadline: String?
    
    init(title: String, description: String?, deadline: String?) {
        self.title = title
        self.description = description
        self.deadline = deadline
    }
}
