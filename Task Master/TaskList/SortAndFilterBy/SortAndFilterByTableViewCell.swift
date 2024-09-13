//
//  SortAndFilterByTableViewCell.swift
//  Task Master
//
//  Created by Rahul Anand on 02/09/24.
//

import UIKit

class SortAndFilterByTableViewCell: UITableViewCell {

    @IBOutlet weak var sortByLabel: UILabel!
    @IBOutlet weak var sortByCellSelected: UIImageView!
    
    func setTitleForSortByCell(sortBy: SortByType, isSelected: Bool) {
        self.sortByLabel.text = sortBy.rawValue
        if isSelected == true {
            self.sortByCellSelected.image = UIImage(named: "tick")
        } else {
            self.sortByCellSelected.image = nil
        }
    }
    
    func setSelectedCell() {
        self.sortByCellSelected.image = UIImage(named: "tick")
    }
    
    func removeSelectionOfCell() {
        self.sortByCellSelected.image = nil
    }

}
