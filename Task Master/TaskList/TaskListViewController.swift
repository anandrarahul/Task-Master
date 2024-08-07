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
            if let timeInterval = self.timeIntervalBetweenCurrentDateAnd(dateString: task.taskDeadline!), timeInterval < 0 {
                self.deadlineMissedTaskDetailsList.append(task)
            } else if task.taskStatus == "To Do" {
                self.toDoTaskDetailsList.append(task)
            } else if task.taskStatus == "Done" {
                self.doneTaskDetailsList.append(task)
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
        let addTaskViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AddTaskViewController") as! AddTaskViewController
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
        //        let detailsViewControllerDataSource = DetailsViewControllerDataSource(taskTitle: taskTitleList[indexPath.row], taskDescription: taskDescriptionList[indexPath.row])
        //        let detailsViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DetailsViewController") as! DetailsViewController
        //        detailsViewController.detailsViewControllerDataSource = detailsViewControllerDataSource
        //        self.navigationController?.pushViewController(detailsViewController, animated: true)
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

