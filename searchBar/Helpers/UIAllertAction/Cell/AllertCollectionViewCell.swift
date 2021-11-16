//
//  AllertCollectionViewCell.swift
//  searchBar
//
//  Created by User on 05.11.2021.
//

import UIKit

class AllertCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var imageCell: UIImageView!
    @IBOutlet weak var label: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func config(text: String, image: String) {
        imageCell.image = UIImage(named: image)
        label.text = text
    }

}
