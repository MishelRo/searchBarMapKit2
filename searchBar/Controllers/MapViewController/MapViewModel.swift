//
//  MapViewModel.swift
//  searchBar
//
//  Created by User on 20.10.2021.
//

protocol MapViewModelProtocol {
    var dataJson: [Model] {get set}
    var arrayOfAnotation: [MKPointAnnotation] {get set}
    func getDataToCoreData(complession: @escaping()->())
    func getData( complession: @escaping ([Model])->())
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String, complession: @escaping([Model])->())
    func clean(complession: @escaping(MKPointAnnotation)->())
    func setPlaceMark(model: Model, complession: @escaping(MKPointAnnotation)->())
    func setPoints(points: [Model], complession: @escaping(MKPointAnnotation)->())
    func sorted(state: Int, complession: @escaping((MKPointAnnotation)->()))
    func savePoint(points: newPoint)
}

import UIKit
import MapKit
class MapViewModel: MapViewModelProtocol {
    
    var filteredWorkItems = [Model]()
    var dataJson = [Model]()
    var arrayOfAnotation = [MKPointAnnotation]()
    
    func sorted(state: Int, complession: @escaping((MKPointAnnotation)->())) {
        for item in dataJson {
            if item.state == state {
                setPlaceMark(model: item) { item in
                    complession(item)
                }
            }
        }
    }
    
    func getDataToCoreData(complession: @escaping()->()) {
        NetworkManager().getData { data in
            CoreDataManager.shared.saveToCD(data: data) {
                complession()
            }
        }
    }
    
    func getData( complession: @escaping ([Model])->()) {
        CoreDataManager.shared.loadData(complession: { [unowned self] data  in
            do {
                let decodedData = try JSONDecoder().decode([Model].self, from: data)
                dataJson = decodedData
                complession(decodedData)
            } catch {
                print(error.localizedDescription)
            }
        }, entity: .dataCD) {
        }
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String, complession: @escaping([Model])->()) {
        self.filteredWorkItems = self.dataJson.filter({( work: Model) -> Bool in
            let stringMatch = work.id.range(of: searchText)
            return stringMatch != nil
        })
        complession(filteredWorkItems)
    }
    
    func clean(complession: @escaping(MKPointAnnotation)->()) {
        if arrayOfAnotation.count > 0 {
            for item in arrayOfAnotation {
                complession(item)
            }
        }
    }
    
    func setPlaceMark(model: Model, complession: @escaping(MKPointAnnotation)->()) {
        let annotation = MKPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2D(latitude: model.lat, longitude: model.lon)
        annotation.title = model.id
        
        annotation.subtitle = "\(model.heading)"
        arrayOfAnotation.append(annotation)
        complession(annotation)
    }
    
    func setPoints(points: [Model], complession: @escaping(MKPointAnnotation)->()) {
        let queque = DispatchQueue.init(label: "", qos: .utility)
        queque.sync { [self] in
            for item in points{
                let annotation = MKPointAnnotation()
                annotation.coordinate = CLLocationCoordinate2D(latitude: item.lat, longitude: item.lon)
                annotation.title = "id - \(item.id)"
                annotation.subtitle = "heading \(item.heading)"
                arrayOfAnotation.append(annotation)
                complession(annotation)
            }
        }
    }
    func savePoint(points: newPoint) {
        CoreDataManager.shared.saveCDNewPoint(data: Model(id: points.lon + points.lat, lat: Double(points.lat)!, lon: Double(points.lon)!, state: 22, heading: 0)) {
        }
    }
}

