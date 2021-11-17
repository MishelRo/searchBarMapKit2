//
//  UiAlertController.swift
//  searchBar
//
//  Created by User on 17.11.2021.
//

import Foundation
import UIKit
extension UIAlertController {
    
    static   func setNewCoordinate(completion: @escaping((newPoint)->()),
                                   alertCompletion: @escaping((UIAlertController)->())) {
        let alert = UIAlertController(title: "Set new coordinate",
                                      message: "Enter new coordinate",
                                      preferredStyle: .alert)
        alert.addTextField { (idTF) in
            idTF.placeholder = "enter latitude"
        }
        alert.addTextField { (idTF) in
            idTF.placeholder = "enter longitude"
        }
        
        let firstTextField = alert.textFields![0] as UITextField
        let secondTextField = alert.textFields![1] as UITextField
        let ok = UIAlertAction(title: "OK", style: .default) { _ in
            let newPoint = newPoint(lat: firstTextField.text ?? "", lon: secondTextField.text ?? "")
            completion(newPoint)
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(ok)
        alert.addAction(cancel)
        alertCompletion(alert)
    }
    
}
