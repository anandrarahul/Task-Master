//
//  TaskListViewModel.swift
//  Task Master
//
//  Created by Rahul Anand on 24/08/24.
//

import Foundation

class TaskListViewModel {
    private(set) var toDoTaskDetailsList = [TaskDetails]()
    private(set) var doneTaskDetailsList = [TaskDetails]()
    private(set) var deadlineMissedTaskDetailsList = [TaskDetails]()
    private(set) var recommendedTaskDetailsList = [TaskDetails]()
    
    func clearRecordsBeforeFetch() {
        self.toDoTaskDetailsList.removeAll()
        self.doneTaskDetailsList.removeAll()
        self.deadlineMissedTaskDetailsList.removeAll()
        self.recommendedTaskDetailsList.removeAll()
    }
    
    func fetchTasks(coreDataManager: TaskMasterCoreDataManager = .shared) {
        self.clearRecordsBeforeFetch()
        let allTasks = coreDataManager.fetchAllTasks()
        for task in allTasks {
            if task.taskStatus == "Done" {
                self.doneTaskDetailsList.insert(task, at: 0)
            } else if let timeInterval = self.timeIntervalBetweenCurrentDateAnd(dateString: task.taskDeadline!), timeInterval < 0 {
                self.deadlineMissedTaskDetailsList.insert(task, at: 0)
            } else if task.taskStatus == "To Do" {
                self.toDoTaskDetailsList.insert(task, at: 0)
            }
        }
    }
    
    func sortBySelectedType(sortByType: SortByType) {
        if sortByType.rawValue == "A-Z" {
            self.toDoTaskDetailsList = self.toDoTaskDetailsList.sorted(by: { $0.taskTitle! < $1.taskTitle! })
            self.doneTaskDetailsList = self.doneTaskDetailsList.sorted(by: { $0.taskTitle! < $1.taskTitle! })
            self.deadlineMissedTaskDetailsList = self.deadlineMissedTaskDetailsList.sorted(by: { $0.taskTitle! < $1.taskTitle! })
        } else if sortByType.rawValue == "Z-A" {
            self.toDoTaskDetailsList = self.toDoTaskDetailsList.sorted(by: { $0.taskTitle! > $1.taskTitle! })
            self.doneTaskDetailsList = self.doneTaskDetailsList.sorted(by: { $0.taskTitle! > $1.taskTitle! })
            self.deadlineMissedTaskDetailsList = self.deadlineMissedTaskDetailsList.sorted(by: { $0.taskTitle! > $1.taskTitle! })
        } else if sortByType.rawValue == "Recently Added" {
            self.toDoTaskDetailsList = self.toDoTaskDetailsList.sorted(by: { $0.taskDeadline! > $1.taskDeadline! })
            self.doneTaskDetailsList = self.doneTaskDetailsList.sorted(by: { $0.taskDeadline! > $1.taskDeadline! })
            self.deadlineMissedTaskDetailsList = self.deadlineMissedTaskDetailsList.sorted(by: { $0.taskDeadline! > $1.taskDeadline! })
        }
    }
    
    func searchTasks(query: String, coreDataManager: TaskMasterCoreDataManager = .shared) {
        self.recommendedTaskDetailsList.removeAll()
        let allTasks = coreDataManager.fetchAllTasks()
        let filteredTasks = allTasks.filter { task in
            let titleContains = task.taskTitle?.localizedCaseInsensitiveContains(query) ?? false
            let descriptionContains = task.taskDescription?.localizedCaseInsensitiveContains(query) ?? false
            return titleContains || descriptionContains
        }
        self.recommendedTaskDetailsList.append(contentsOf: filteredTasks)
    }
    
    private func timeIntervalBetweenCurrentDateAnd(dateString: String, dateFormat: String = "dd-MM-yyyy") -> TimeInterval? {
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
    
    func tasks(for section: TaskListStatus) -> [TaskDetails] {
        switch section {
        case .recommended:
            return self.recommendedTaskDetailsList
        case .toDo:
            return self.toDoTaskDetailsList
        case .done:
            return self.doneTaskDetailsList
        case .deadlineMissed:
            return self.deadlineMissedTaskDetailsList
        }
    }
    
    private func deleteARecommendedTask(taskTodelete: TaskDetails) {
        let status = taskTodelete.taskStatus
        if status == "To Do", let timeInterval = self.timeIntervalBetweenCurrentDateAnd(dateString: taskTodelete.taskDeadline!), timeInterval < 0 {
            if let rowToDelete = self.deadlineMissedTaskDetailsList.firstIndex(of: taskTodelete) {
                self.deadlineMissedTaskDetailsList.remove(at: rowToDelete)
            }
        }else if status == "To Do" {
            if let rowToDelete = self.toDoTaskDetailsList.firstIndex(of: taskTodelete) {
                self.toDoTaskDetailsList.remove(at: rowToDelete)
            }
        } else if status == "Done" {
            if let rowToDelete = self.doneTaskDetailsList.firstIndex(of: taskTodelete) {
                self.doneTaskDetailsList.remove(at: rowToDelete)
            }
        }
    }
    
    func deleteATask(for section: TaskListStatus, rowToDelete: Int) {
        switch section {
        case .recommended:
            let recommendedTaskToDelete = self.recommendedTaskDetailsList[rowToDelete]
            self.deleteARecommendedTask(taskTodelete: recommendedTaskToDelete)
            self.recommendedTaskDetailsList.remove(at: rowToDelete)
        case .toDo:
            self.toDoTaskDetailsList.remove(at: rowToDelete)
        case .done:
            self.doneTaskDetailsList.remove(at: rowToDelete)
        case .deadlineMissed:
            self.deadlineMissedTaskDetailsList.remove(at: rowToDelete)
        }
    }
}
