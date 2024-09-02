//
//  SortByTableViewCell.swift
//  Task Master
//
//  Created by Rahul Anand on 02/09/24.
//

import UIKit

class SortByTableViewCell: UITableViewCell {

    @IBOutlet weak var sortByLabel: UILabel!
    @IBOutlet weak var sortByCellSelected: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func setTitleForSortByCell(sortBy: String, isSelected: Bool) {
        self.sortByLabel.text = sortBy
        if isSelected == true {
            self.sortByCellSelected.image = UIImage(named: "tick")
        } else {
            self.sortByCellSelected.image = UIImage(named: "")
        }
    }

}
