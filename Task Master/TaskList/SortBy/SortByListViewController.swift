//
//  SortByListViewController.swift
//  Task Master
//
//  Created by Rahul Anand on 29/07/24.
//

import UIKit

protocol SortByDelegate: NSObject {
    func sortBySelectedType(sortByType: SortByType)
}

enum SortByType: String, CaseIterable {
    case aToZ = "A-Z"
    case zToA = "Z-A"
    case recentlyAdded = "Recently Added"
}

class SortByListViewController: UIViewController {
    
    @IBOutlet weak var sortByTableView: UITableView!
    var secletedRow: SortByType?
    weak var sortByDelegate: SortByDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Sort By"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(self.saveButtonTapped))
        self.sortByTableView.dataSource = self
        self.sortByTableView.delegate = self
    }
    
    @objc func saveButtonTapped() {
        if let sortByRow = self.secletedRow {
            self.sortByDelegate?.sortBySelectedType(sortByType: sortByRow)
            self.navigationController?.popViewController(animated: true)
        }
    }
}

extension SortByListViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        SortByType.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.sortByTableView.dequeueReusableCell(withIdentifier: "SortByTableViewCell", for: indexPath) as! SortByTableViewCell
        let taskRow = SortByType.allCases[indexPath.row]
        let isSelected = (taskRow == self.secletedRow)
        cell.setTitleForSortByCell(sortBy: taskRow, isSelected: isSelected)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.sortByTableView.deselectRow(at: indexPath, animated: true)
        let selectedSortType = SortByType.allCases[indexPath.row]
        
        if let previousSelectedSortType = secletedRow,
           let previousSelectedRow = SortByType.allCases.firstIndex(of: previousSelectedSortType) {
            let previousSelectedIndexPath = IndexPath(row: previousSelectedRow, section: 0)
            if let previousSelectedCell = tableView.cellForRow(at: previousSelectedIndexPath) as? SortByTableViewCell {
                previousSelectedCell.removeSelectionOfCell()
            }
        }
        
        let selectedCell = self.sortByTableView.cellForRow(at: indexPath) as? SortByTableViewCell
        selectedCell?.setSelectedCell()
        
        self.secletedRow = selectedSortType
    }
}
