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
    
    func createTask(title: String, description: String?, status: String, deadline: String?) {
        let taskRecord = TaskRecord(context: context)
        taskRecord.taskTitle = title
        taskRecord.taskDescription = description
        taskRecord.taskStatus = status
        taskRecord.taskDeadline = deadline
        saveContext()
    }
    
    func fetchAllTasks() -> [TaskRecord] {
        let fetchRequest: NSFetchRequest<TaskRecord> = TaskRecord.fetchRequest()
        do {
            return try context.fetch(fetchRequest)
        } catch {
            print("Failed to fetch tasks: \(error)")
            return []
        }
    }
    
    func updateTask(taskRecord: TaskRecord, title: String?, description: String?, status: String, deadline: String?) {
        if let title = title {
            taskRecord.taskTitle = title
        }
        if let description = description {
            taskRecord.taskDescription = description
        }
        taskRecord.taskStatus = status
        if let deadline = deadline {
            taskRecord.taskDeadline = deadline
        }
        saveContext()
    }
    
    func deleteTask(taskRecord: TaskRecord) {
        context.delete(taskRecord)
        saveContext()
    }
}
