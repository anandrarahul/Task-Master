//
//  DetailsViewController.swift
//  Task Master
//
//  Created by Rahul Anand on 29/07/24.
//

import UIKit

class DetailsViewControllerDataSource {
    let taskTitle: String?
    let taskDescription: String?
    
    init(taskTitle: String?, taskDescription: String?) {
        self.taskTitle = taskTitle
        self.taskDescription = taskDescription
    }
}

class DetailsViewController: UIViewController {

    @IBOutlet weak var taskDescription: UILabel!
    @IBOutlet weak var yesButtonOutlet: UIButton!
    @IBOutlet weak var noButtonOutlet: UIButton!
    
    @IBAction func yesButtonTapped(_ sender: UIButton) {
        sender.tintColor = .green
        self.noButtonOutlet.tintColor = .systemBlue
    }
    
    @IBAction func noButtonTapped(_ sender: UIButton) {
        sender.tintColor = .red
        self.yesButtonOutlet.tintColor = .systemBlue
    }
    
    var detailsViewControllerDataSource: DetailsViewControllerDataSource?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.yesButtonOutlet.tintColor = .systemBlue
        self.noButtonOutlet.tintColor = .systemBlue
        guard let title = detailsViewControllerDataSource?.taskTitle else {
            return
        }
        self.navigationItem.title = title
        guard let desc = detailsViewControllerDataSource?.taskDescription else {
            return
        }
        self.taskDescription.text = desc
    }

}
