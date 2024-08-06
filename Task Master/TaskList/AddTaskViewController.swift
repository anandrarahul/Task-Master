//
//  AddTaskViewController.swift
//  Task Master
//
//  Created by Rahul Anand on 31/07/24.
//

import UIKit

class AddTaskViewController: UIViewController {

    @IBOutlet weak var addTitleLabel: UITextField!
    @IBOutlet weak var addDescriptionLabel: UITextView!
    @IBOutlet weak var addDeadlineLabel: UITextField!
    
    private var datePicker: UIDatePicker?
    
    @IBAction func saveButtonTapped(_ sender: UIButton) {
        if let title = self.addTitleLabel.text, title != "" {
            TaskMasterCoreDataManager.shared.createTask(title: title, description: self.addDescriptionLabel.text, status: "To Do", deadline: self.addDeadlineLabel.text)
            self.navigationController?.popViewController(animated: true)
        } else {
            let emptyTitleAlert = UIAlertController(title: "Title Empty!", message: "Please Enter a valid title.", preferredStyle: .alert)
            let okButton = UIAlertAction(title: "Ok", style: .cancel)
            emptyTitleAlert.addAction(okButton)
            self.present(emptyTitleAlert, animated: true)
        }
    }
    
    private func setupDatePicker() {
        datePicker = UIDatePicker()
        datePicker?.datePickerMode = .date
        datePicker?.preferredDatePickerStyle = .inline
        datePicker?.addTarget(self, action: #selector(dateChanged(_:)), for: .valueChanged)
        self.addDeadlineLabel.inputView = datePicker
        
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
        view.endEditing(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Add Tasks"
        self.addTitleLabel.delegate = self
        self.addDescriptionLabel.delegate = self
        self.setupDatePicker()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        self.view.addGestureRecognizer(tapGesture)
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
