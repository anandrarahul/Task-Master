//
//  TaskListViewController.swift
//  Task Master
//
//  Created by Rahul Anand on 28/07/24.
//

import UIKit

enum TaskListSection: String, CaseIterable {
    case toDo = "To Do"
    case done = "Done"
}

class TaskListViewController: UIViewController {

    @IBOutlet weak var taskListTableView: UITableView!
    
    var taskTitleList = ["Fish Food", "Water Plants", "Drink Water", "Cook Food", "Family Time"]
    var taskDescriptionList = ["Fish Food keeps fishes alive.", "Water keeps Plants healthy, plants also need sunlight.", "Start your day with a glass of Water", "Cook delicious and healthy Food.", "Family Time is the best time."]
    let taskDoneList = ["fish", "plants"]
    
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
    
    @objc func addButtonTapped() {
        let addTaskViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AddTaskViewController") as! AddTaskViewController
        addTaskViewController.delegate = self
        self.navigationController?.pushViewController(addTaskViewController, animated: true)
    }
}

extension TaskListViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        TaskListSection.allCases.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard let taskSection = TaskListSection.allCases[safe: section] else {
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
        titleLabel.text = TaskListSection.allCases[safe: section]?.rawValue
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
        guard let taskSection = TaskListSection.allCases[safe: section] else {
            return 0
        }
        
        switch taskSection {
        case .toDo:
            return taskTitleList.count
        case .done:
            return taskDoneList.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let taskCell = self.taskListTableView.dequeueReusableCell(withIdentifier: "TaskTableViewCell", for: indexPath) as! TaskTableViewCell
        
        guard let taskSection = TaskListSection.allCases[safe: indexPath.section] else {
            return taskCell
        }
        
        switch taskSection {
        case .toDo:
            taskCell.setTaskDetails(title: taskTitleList[indexPath.row], desc: taskDescriptionList[indexPath.row])
        case .done:
            taskCell.setTaskDetails(title: taskDoneList[indexPath.row], desc: taskDescriptionList[indexPath.row])
        }
        return taskCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailsViewControllerDataSource = DetailsViewControllerDataSource(taskTitle: taskTitleList[indexPath.row], taskDescription: taskDescriptionList[indexPath.row])
        let detailsViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DetailsViewController") as! DetailsViewController
        detailsViewController.detailsViewControllerDataSource = detailsViewControllerDataSource
        self.navigationController?.pushViewController(detailsViewController, animated: true)
    }
    
}

extension TaskListViewController: SaveDetailsDelegate {
    func saveDetails(title: String, desc: String) {
        self.taskTitleList.append(title)
        self.taskDescriptionList.append(desc)
        self.taskListTableView.reloadData()
    }
}

extension Collection {
    subscript(safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}

