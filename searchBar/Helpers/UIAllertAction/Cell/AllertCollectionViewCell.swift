//
//  AllertCollectionViewCell.swift
//  searchBar
//
//  Created by User on 05.11.2021.
//

import UIKit
import SnapKit

class AllertCollectionViewCell: UICollectionViewCell {
    
    
    var imageCell: UIImageView!
    var label: UILabel!
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func config(text: String, image: String) {
        label = UILabel()
        imageCell = UIImageView()
        self.addSubview(imageCell)
        imageCell.snp.makeConstraints { make in
            make.width.equalTo(40)
            make.top.equalTo(self.snp.top).offset(10)
            make.leading.equalTo(self.snp.leading).offset(15)
            make.bottom.equalTo(self.snp.bottom).offset(-5)
        }
        self.addSubview(label)
        label.snp.makeConstraints { make in
            make.leading.equalTo(imageCell.snp.trailing)
            make.top.equalTo(self.snp.top).offset(10)
            make.bottom.equalTo(self.snp.bottom).offset(-5)
        }
        imageCell.image = UIImage(named: image)
        label.text = text
    }

}
