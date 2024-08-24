//
//  TaskListViewController.swift
//  Task Master
//
//  Created by Rahul Anand on 28/07/24.
//

import UIKit

enum TaskListStatus: String, CaseIterable {
    case recommended = "Recommended"
    case toDo = "To Do"
    case done = "Done"
    case deadlineMissed = "Deadline Missed"
}

class TaskListViewController: UIViewController {

    @IBOutlet weak var taskListTableView: UITableView!
    @IBOutlet weak var taskSearchBar: UISearchBar!
    
    private var searchDebouncer: SearchDebouncer!
    private var viewModel = TaskListViewModel()
    var canEditRow: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Tasks"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add", style: .done, target: self, action: #selector(self.addButtonTapped))
        self.taskListTableView.layer.opacity = 0.85
        self.taskListTableView.dataSource = self
        self.taskListTableView.delegate = self
        self.taskSearchBar.delegate = self
        self.searchDebouncer = SearchDebouncer(delay: 0.5)
        self.addDoneButtonToToolBar()
        let taskCellNib = UINib(nibName: "TaskTableViewCell", bundle: nil)
        self.taskListTableView.register(taskCellNib, forCellReuseIdentifier: "TaskTableViewCell")
        self.addFooterToTheTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.viewModel.fetchTasks()
        self.taskListTableView.reloadData()
    }
    
    private func addDoneButtonToToolBar() {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissKeyboard))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolbar.setItems([flexibleSpace, doneButton], animated: true)
        self.taskSearchBar.inputAccessoryView = toolbar
    }
    
    @objc func addButtonTapped() {
        self.dismissKeyboard()
        let addTaskViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AddTaskViewController") as! AddAndEditTaskViewController
        addTaskViewController.setNavigationItemsTitle(navigationTitle: "Add Tasks")
        self.navigationController?.pushViewController(addTaskViewController, animated: true)
    }
    
    @objc private func dismissKeyboard() {
        self.view.endEditing(true)
    }
    
    private func getAppVersion() -> String {
        if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String,
           let build = Bundle.main.infoDictionary?["CFBundleVersion"] as? String {
            print("Version \(version) (\(build))")
            return "Version: \(version)"
        }
        return "Version: 00.00.0"
    }
    
    private func addFooterToTheTableView() {
        let footerView = UIView()
        footerView.backgroundColor = .systemBackground
        footerView.frame = CGRect(x: 0, y: 0, width: self.taskListTableView.frame.width, height: 50)
        let footerLabel = UILabel()
        footerLabel.text = self.getAppVersion()
        footerLabel.textColor = .gray
        footerLabel.textAlignment = .center
        footerLabel.frame = footerView.bounds
        footerView.addSubview(footerLabel)
        
        self.taskListTableView.tableFooterView = footerView
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
        return self.viewModel.tasks(for: taskSection).count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let taskCell = self.taskListTableView.dequeueReusableCell(withIdentifier: "TaskTableViewCell", for: indexPath) as! TaskTableViewCell
        
        guard let taskSection = TaskListStatus.allCases[safe: indexPath.section] else {
            return taskCell
        }
        taskCell.delegate = self
        taskCell.setTaskDetails(taskDetails: self.viewModel.tasks(for: taskSection)[indexPath.row])
        return taskCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let editTaskViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AddTaskViewController") as! AddAndEditTaskViewController
        var task: TaskDetails?
        if let taskSection = TaskListStatus.allCases[safe: indexPath.section] {
            task = self.viewModel.tasks(for: taskSection)[indexPath.row]
        }
        if let selectedTask = task {
            let editTaskViewControllerDataSource = EditTaskViewControllerDataSource(taskDetails: selectedTask, navigationTitle: "Edit Task")
            editTaskViewController.editTaskViewControllerDataSource = editTaskViewControllerDataSource
            self.navigationController?.pushViewController(editTaskViewController, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return self.canEditRow
    }
        
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if let taskSection = TaskListStatus.allCases[safe: indexPath.section] {
                let taskToDelete: TaskDetails
                taskToDelete = self.viewModel.tasks(for: taskSection)[indexPath.row]
                self.viewModel.deleteATask(for: taskSection, rowToDelete: indexPath.row)
                TaskMasterCoreDataManager.shared.deleteTask(taskDetails: taskToDelete)
                self.taskListTableView.reloadData()
            }
        }
    }
}

extension TaskListViewController: SaveDetailsDelegate {
    
    func updateTaskDetails() {
        self.viewModel.fetchTasks()
        self.taskListTableView.reloadData()
    }
}

extension TaskListViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchDebouncer.debounce {
            self.viewModel.searchTasks(query: searchText)
            self.taskListTableView.reloadSections(IndexSet(integer: 0), with: .fade)
        }
    }
}

extension Collection {
    subscript(safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}

