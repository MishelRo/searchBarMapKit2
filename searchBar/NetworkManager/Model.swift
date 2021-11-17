//
//  Model.swift
//  searchBar
//
//  Created by User on 20.10.2021.
//

import Foundation

struct Model: Codable {
    let id: String
    let lat, lon: Double
    let state, heading: Int
}

struct newPoint: Codable {
    let lat: String
    let lon: String
}
