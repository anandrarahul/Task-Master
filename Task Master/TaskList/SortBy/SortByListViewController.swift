//
//  SortByListViewController.swift
//  Task Master
//
//  Created by Rahul Anand on 29/07/24.
//

import UIKit

protocol SortByDelegate: NSObject {
    func sortBySelectedType()
}

class SortByListViewController: UIViewController {
    
    @IBOutlet weak var sortByTableView: UITableView!
    var sortByType = ["A-Z", "Z-A", "Date Added"]
    var secletedRow = 2
    weak var sortByDelegate: SortByDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.sortByTableView.dataSource = self
        self.sortByTableView.delegate = self
    }
}

extension SortByListViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.sortByType.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.sortByTableView.dequeueReusableCell(withIdentifier: "SortByTableViewCell", for: indexPath) as! SortByTableViewCell
        cell.setTitleForSortByCell(sortBy: self.sortByType[indexPath.row], isSelected: indexPath.row == secletedRow)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}