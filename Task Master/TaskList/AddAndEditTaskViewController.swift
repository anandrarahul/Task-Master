//
//  AddAndEditTaskViewController.swift
//  Task Master
//
//  Created by Rahul Anand on 31/07/24.
//

import UIKit

class EditTaskViewControllerDataSource {
    
    let taskDetails: TaskDetails?
    let navigationTitle: String?
    
    init(taskDetails: TaskDetails?, navigationTitle: String?) {
        self.taskDetails = taskDetails
        self.navigationTitle = navigationTitle
    }
}

class AddAndEditTaskViewController: UIViewController {

    @IBOutlet weak var addTitleLabel: UITextField!
    @IBOutlet weak var addDescriptionLabel: UITextView!
    @IBOutlet weak var addDeadlineLabel: UITextField!
    
    private var datePicker: UIDatePicker?
    var editTaskViewControllerDataSource: EditTaskViewControllerDataSource?
    
    @IBAction func saveButtonTapped(_ sender: UIButton) {
        guard let title = self.addTitleLabel.text, !title.isEmpty else {
            self.presentAlertForInvalidTitle()
            return
        }
        let description = self.addDescriptionLabel.text
        let deadline = self.addDeadlineLabel.text
        
        if let taskToEdit = self.editTaskViewControllerDataSource, let task = taskToEdit.taskDetails {
            TaskMasterCoreDataManager.shared.updateTask(taskDetails: task, title: title, description: description, status: task.taskStatus ?? "To Do", deadline: deadline)
        } else {
            TaskMasterCoreDataManager.shared.createTask(title: title, description: description, status: "To Do", deadline: deadline)
        }
        self.scheduleAlocalNotification()
        self.navigationController?.popViewController(animated: true)
    }
    
    func presentAlertForInvalidTitle() {
        let emptyTitleAlert = UIAlertController(title: "Title Empty!", message: "Please Enter a valid title.", preferredStyle: .alert)
        let okButton = UIAlertAction(title: "Ok", style: .cancel)
        emptyTitleAlert.addAction(okButton)
        self.present(emptyTitleAlert, animated: true)
    }
    
    private func setupDatePicker() {
        self.datePicker = UIDatePicker()
        self.datePicker?.datePickerMode = .date
        self.datePicker?.preferredDatePickerStyle = .inline
        self.datePicker?.addTarget(self, action: #selector(dateChanged(_:)), for: .valueChanged)
        self.addDeadlineLabel.inputView = self.datePicker
        
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneTapped))
        toolbar.setItems([doneButton], animated: true)
        self.addDeadlineLabel.inputAccessoryView = toolbar
        self.addDeadlineLabel.textColor = .red
    }
    
    @objc private func dateChanged(_ sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        self.addDeadlineLabel.text = dateFormatter.string(from: sender.date)
    }

    @objc private func doneTapped() {
        self.addDeadlineLabel.resignFirstResponder()
    }
    
    @objc private func dismissKeyboard() {
        self.view.endEditing(true)
    }
    
    func setTaskDetailsAndNavigationTitle() {
        if let title = self.editTaskViewControllerDataSource?.taskDetails?.taskTitle {
            self.addTitleLabel.text = title
        }
        if let description = self.editTaskViewControllerDataSource?.taskDetails?.taskDescription {
            self.addDescriptionLabel.text = description
        }
        if let deadline = self.editTaskViewControllerDataSource?.taskDetails?.taskDeadline {
            self.addDeadlineLabel.text = deadline
        }
        if let navigationTitle = self.editTaskViewControllerDataSource?.navigationTitle {
            self.setNavigationItemsTitle(navigationTitle: navigationTitle)
        }
    }
    
    func setNavigationItemsTitle(navigationTitle: String) {
        self.navigationItem.title = navigationTitle
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.addTitleLabel.delegate = self
        self.addDescriptionLabel.delegate = self
        self.setupDatePicker()
        self.setTaskDetailsAndNavigationTitle()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        self.view.addGestureRecognizer(tapGesture)
    }
    
    func scheduleAlocalNotification() {
        if let deadline = self.addDeadlineLabel.text, deadline != "" {
            if let timeInterval = self.timeIntervalBetweenCurrentDateAnd(dateString: deadline), timeInterval > 0 {
                let bufferTime: Double = 60 * 60 * 14; //60 seconds * 60 minutes * 14 for 14 hours. So, that the notification will be send at 10 am one day before.
                LocalNotificationManager.shared.scheduleNotification(title: self.addTitleLabel.text!, body: self.addDescriptionLabel.text!, timeInterval: timeInterval - bufferTime)
                print(timeInterval)
            }
        }
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

}

extension AddAndEditTaskViewController: UITextFieldDelegate, UITextViewDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == self.addTitleLabel {
            self.addDescriptionLabel.becomeFirstResponder()
        }
        return true
    }
}
