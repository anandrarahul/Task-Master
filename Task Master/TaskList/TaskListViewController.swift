//
//  TaskListViewController.swift
//  Task Master
//
//  Created by Rahul Anand on 28/07/24.
//

import UIKit

enum TaskListStatus: String, CaseIterable {
    case toDo = "To Do"
    case done = "Done"
    case deadlineMissed = "Deadline Missed"
}

class TaskListViewController: UIViewController {

    @IBOutlet weak var taskListTableView: UITableView!
    
    var toDoTaskDetailsList =  [TaskDetails]()
    var doneTaskDetailsList =  [TaskDetails]()
    var deadlineMissedTaskDetailsList =  [TaskDetails]()
    var canEditRow: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Tasks"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add", style: .done, target: self, action: #selector(self.addButtonTapped))
        self.taskListTableView.layer.opacity = 0.85
        self.taskListTableView.dataSource = self
        self.taskListTableView.delegate = self
        let taskCellNib = UINib(nibName: "TaskTableViewCell", bundle: nil)
        self.taskListTableView.register(taskCellNib, forCellReuseIdentifier: "TaskTableViewCell")
    }
    
    private func clearRecordsBeforeFetch() {
        self.toDoTaskDetailsList.removeAll()
        self.doneTaskDetailsList.removeAll()
        self.deadlineMissedTaskDetailsList.removeAll()
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
    
    private func fetchAndReloadRecords() {
        let allTasks = TaskMasterCoreDataManager.shared.fetchAllTasks()
        for task in allTasks {
            if task.taskStatus == "Done" {
                self.doneTaskDetailsList.append(task)
            } else if let timeInterval = self.timeIntervalBetweenCurrentDateAnd(dateString: task.taskDeadline!), timeInterval < 0 {
                self.deadlineMissedTaskDetailsList.append(task)
            } else if task.taskStatus == "To Do" {
                self.toDoTaskDetailsList.append(task)
            }
        }
        self.taskListTableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.clearRecordsBeforeFetch()
        self.fetchAndReloadRecords()
    }
    
    @objc func addButtonTapped() {
        let addTaskViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AddTaskViewController") as! AddAndEditTaskViewController
        addTaskViewController.setNavigationItemsTitle(navigationTitle: "Add Tasks")
        self.navigationController?.pushViewController(addTaskViewController, animated: true)
    }

}

extension TaskListViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        TaskListStatus.allCases.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard let taskSection = TaskListStatus.allCases[safe: section] else {
            return nil
        }
        return taskSection.rawValue
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = .lightGray
        
        let titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.textColor = .systemBackground
        titleLabel.font = UIFont.boldSystemFont(ofSize: 20)
        titleLabel.text = TaskListStatus.allCases[safe: section]?.rawValue
        headerView.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -20),
            titleLabel.topAnchor.constraint(equalTo: headerView.topAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: headerView.bottomAnchor)
        ])
        
        return headerView
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44.0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let taskSection = TaskListStatus.allCases[safe: section] else {
            return 0
        }
        
        switch taskSection {
        case .toDo:
            return self.toDoTaskDetailsList.count
        case .done:
            return self.doneTaskDetailsList.count
        case .deadlineMissed:
            return self.deadlineMissedTaskDetailsList.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let taskCell = self.taskListTableView.dequeueReusableCell(withIdentifier: "TaskTableViewCell", for: indexPath) as! TaskTableViewCell
        
        guard let taskSection = TaskListStatus.allCases[safe: indexPath.section] else {
            return taskCell
        }
        taskCell.delegate = self
        
        switch taskSection {
        case .toDo:
            taskCell.setTaskDetails(taskDetails: self.toDoTaskDetailsList[indexPath.row])
        case .done:
            taskCell.setTaskDetails(taskDetails: self.doneTaskDetailsList[indexPath.row])
        case .deadlineMissed:
            taskCell.setTaskDetails(taskDetails: self.deadlineMissedTaskDetailsList[indexPath.row])
        }
        return taskCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let editTaskViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AddTaskViewController") as! AddAndEditTaskViewController
        let task: TaskDetails
        if indexPath.section == 0 {
            task = self.toDoTaskDetailsList[indexPath.row]
        } else if indexPath.section == 1 {
            task = self.doneTaskDetailsList[indexPath.row]
        } else {
            task = self.deadlineMissedTaskDetailsList[indexPath.row]
        }
        let editTaskViewControllerDataSource = EditTaskViewControllerDataSource(taskDetails: task, navigationTitle: "Edit Task")
        editTaskViewController.editTaskViewControllerDataSource = editTaskViewControllerDataSource
        self.navigationController?.pushViewController(editTaskViewController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return self.canEditRow
    }
        
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if let taskSection = TaskListStatus.allCases[safe: indexPath.section] {
                let taskToDelete: TaskDetails
                switch taskSection {
                case .toDo:
                    taskToDelete = self.toDoTaskDetailsList[indexPath.row]
                    self.toDoTaskDetailsList.remove(at: indexPath.row)
                case .done:
                    taskToDelete = self.doneTaskDetailsList[indexPath.row]
                    self.doneTaskDetailsList.remove(at: indexPath.row)
                case .deadlineMissed:
                    taskToDelete = self.deadlineMissedTaskDetailsList[indexPath.row]
                    self.deadlineMissedTaskDetailsList.remove(at: indexPath.row)
                }
                TaskMasterCoreDataManager.shared.deleteTask(taskDetails: taskToDelete)
            }
        }
        self.taskListTableView.deleteRows(at: [indexPath], with: .automatic)
    }
}

extension TaskListViewController: SaveDetailsDelegate {
    
    func updateTaskDetails() {
        self.clearRecordsBeforeFetch()
        self.fetchAndReloadRecords()
    }
}

extension Collection {
    subscript(safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}

