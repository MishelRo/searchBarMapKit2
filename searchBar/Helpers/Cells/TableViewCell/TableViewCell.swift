//
//  TableViewCell.swift
//  searchBar
//
//  Created by User on 25.10.2021.
//

import UIKit

class TableViewCell: UITableViewCell {

    static var reuseId = "Cell"
    static var cellName = "TableViewCell"
    
    
    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var latitudeLabel: UILabel!
    @IBOutlet weak var longitudeLabel: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func cellConfigure(model: Model){
        idLabel.text = "id  \(model.id)"
        latitudeLabel.text = "Latitude   \(model.lat)"
        longitudeLabel.text = "Longitude  \(model.lon)"
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
