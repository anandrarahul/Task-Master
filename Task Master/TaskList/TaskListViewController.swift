//
//  TaskListViewController.swift
//  Task Master
//
//  Created by Rahul Anand on 28/07/24.
//

import UIKit

class TaskListViewController: UIViewController {

    @IBOutlet weak var taskListTableView: UITableView!
    
    var taskTitleList = ["Fish Food", "Water Plants", "Drink Water", "Cook Food", "Family Time"]
    var taskDescriptionList = ["Fish Food keeps fishes alive.", "Water keeps Plants healthy, plants also need sunlight.", "Start your day with a glass of Water", "Cook delicious and healthy Food.", "Family Time is the best time."]
    let taskImageList = ["fish", "plants", "water", "food", "family"]
    
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        taskTitleList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let taskCell = self.taskListTableView.dequeueReusableCell(withIdentifier: "TaskTableViewCell", for: indexPath) as! TaskTableViewCell
        taskCell.setTaskDetails(title: taskTitleList[indexPath.row], desc: taskDescriptionList[indexPath.row]/*, taskImage: taskImageList[indexPath.row]*/)
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

