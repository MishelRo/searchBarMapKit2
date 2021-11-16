//
//  NetworkManager.swift
//  searchBar
//
//  Created by User on 20.10.2021.
//

import UIKit
import Alamofire

class NetworkManager {
    func getData(complession: @escaping(Data)->()) {
        let url = Bundle.main.url(forResource: "data", withExtension: ".json")
        guard let dataURL = url, let data = try? Data(contentsOf: dataURL) else {
             fatalError("Couldn't read data.json file") }
        complession(data)
    }
}

