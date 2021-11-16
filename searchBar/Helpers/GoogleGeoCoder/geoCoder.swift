//
//  geoCoder.swift
//  searchBar
//
//  Created by User on 12.11.2021.
//

import Foundation
import CoreLocation
class GeoLocations {
    
    func geoData(lat: Double, lon: Double, completion: @escaping((CLPlacemark)->()))  {
        let geoCoder = CLGeocoder()
        let location = CLLocation(latitude: lat, longitude: lon)
        var placeMark : CLPlacemark!
        geoCoder.reverseGeocodeLocation(location) {(placemarks, error) in
            guard error == nil else {return}
            placeMark = placemarks![0]
            completion(placeMark)
        }
    }
}
