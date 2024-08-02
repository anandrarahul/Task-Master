//
//  AddTaskViewController.swift
//  Task Master
//
//  Created by Rahul Anand on 31/07/24.
//

import UIKit

protocol SaveDetailsDelegate: NSObject {
    func saveDetails(title: String, desc: String)
}

class AddTaskViewController: UIViewController {

    @IBOutlet weak var addTitleLabel: UITextField!
    @IBOutlet weak var addDescriptionLabel: UITextView!
    weak var delegate: SaveDetailsDelegate?
    
    @IBAction func saveButtonTapped(_ sender: UIButton) {
        if let title = self.addTitleLabel.text, let desc = self.addDescriptionLabel.text {
            self.delegate?.saveDetails(title: title, desc: desc)
            self.navigationController?.popViewController(animated: true)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Add Tasks"
    }

}
