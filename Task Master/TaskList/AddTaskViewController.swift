//
//  AddTaskViewController.swift
//  Task Master
//
//  Created by Rahul Anand on 31/07/24.
//

import UIKit

protocol SaveDetailsDelegate: NSObject {
    func saveDetails(taskDetail: TaskDetails)
    func updateTaskDetails(taskDetail: TaskDetails, taskStatus: TaskListStatus)
}

class AddTaskViewController: UIViewController {

    @IBOutlet weak var addTitleLabel: UITextField!
    @IBOutlet weak var addDescriptionLabel: UITextView!
    weak var delegate: SaveDetailsDelegate?
    
    @IBAction func saveButtonTapped(_ sender: UIButton) {
        if let title = self.addTitleLabel.text {
            let taskDetail = TaskDetails(title: title, description: self.addDescriptionLabel.text, deadline: "Soon")
            self.delegate?.saveDetails(taskDetail: taskDetail)
            self.navigationController?.popViewController(animated: true)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Add Tasks"
        self.addTitleLabel.delegate = self
        self.addDescriptionLabel.delegate = self
        self.addTitleLabel.becomeFirstResponder()
    }

}

extension AddTaskViewController: UITextFieldDelegate, UITextViewDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == self.addTitleLabel {
            self.addDescriptionLabel.becomeFirstResponder()
        }
        return true
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n", textView == self.addDescriptionLabel {
            textView.resignFirstResponder()
        }
        return true
    }
}
