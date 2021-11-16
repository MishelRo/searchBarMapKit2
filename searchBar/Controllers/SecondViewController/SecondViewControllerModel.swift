//
//  SecondViewControllerModel.swift
//  searchBar
//
//  Created by User on 20.10.2021.
//

protocol SecondViewControllerModelProtocol{
    func getData( complession: @escaping ([Model])->())
}


import Foundation
class SecondViewControllerModel  {
    

    func getData( complession: @escaping ([Model])->()) {
        CoreDataManager.shared.loadData(complession: { data in
            do {
                       let decodedData = try JSONDecoder().decode([Model].self, from: data)
                           complession(decodedData)
                       } catch {
                           print(error.localizedDescription)
                       }
        }, entity: .dataCD) {
        }

    }
}
