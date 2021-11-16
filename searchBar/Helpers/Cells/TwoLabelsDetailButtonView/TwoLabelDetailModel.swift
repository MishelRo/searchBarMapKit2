//
//  TwoLabelDetailModel.swift
//  searchBar
//
//  Created by User on 12.11.2021.
//

import Foundation
class TwoLabelDetailModel {
    
    func setPoint(point: Model ) {
        CoreDataManager.shared.removeCoreData()
        CoreDataManager.shared.saveCDNewPoint(data: point) {
        }
    }
}
