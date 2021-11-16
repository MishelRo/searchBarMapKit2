//
//  StateTableViewCell.swift
//  searchBar
//
//  Created by User on 01.11.2021.
//

import UIKit

class StateTableViewCell: UITableViewCell {

    
    
    @IBOutlet weak var imageCell: UIImageView!
    @IBOutlet weak var labelCell: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
