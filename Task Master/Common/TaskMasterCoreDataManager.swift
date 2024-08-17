//
//  TaskMasterCoreDataManager.swift
//  Task Master
//
//  Created by Rahul Anand on 05/08/24.
//

import CoreData
import UIKit

class TaskMasterCoreDataManager {
    static let shared = TaskMasterCoreDataManager()
    private let persistentContainer: NSPersistentContainer
    
    private init() {
        persistentContainer = NSPersistentContainer(name: "Task_Master")
        persistentContainer.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Failed to load Core Data stack: \(error)")
            }
        }
    }
    
    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                context.rollback()
                print("Failed to save context: \(error)")
            }
        }
    }
    
    // MARK: - CRUD Operations
    
    func createTask(taskId: String, title: String, description: String?, status: String, deadline: String?) {
        let taskDetails = TaskDetails(context: context)
        taskDetails.taskId = taskId
        taskDetails.taskTitle = title
        taskDetails.taskDescription = description
        taskDetails.taskStatus = status
        taskDetails.taskDeadline = deadline
        saveContext()
    }
    
    func fetchAllTasks() -> [TaskDetails] {
        let fetchRequest: NSFetchRequest<TaskDetails> = TaskDetails.fetchRequest()
        do {
            return try context.fetch(fetchRequest)
        } catch {
            print("Failed to fetch tasks: \(error)")
            return []
        }
    }
    
    func updateTask(taskDetails: TaskDetails, title: String?, description: String?, status: String, deadline: String?) {
        if let title = title {
            taskDetails.taskTitle = title
        }
        if let description = description {
            taskDetails.taskDescription = description
        }
        taskDetails.taskStatus = status
        if let deadline = deadline {
            taskDetails.taskDeadline = deadline
        }
        saveContext()
    }
    
    func deleteTask(taskDetails: TaskDetails) {
        context.delete(taskDetails)
        saveContext()
    }
}
