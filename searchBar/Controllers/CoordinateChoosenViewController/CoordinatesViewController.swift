//
//  CoordinatesViewController.swift
//  searchBar
//
//  Created by User on 25.10.2021.
//

import UIKit
import MapKit
import SnapKit
class CoordinatesViewController: UIViewController {
    //MARK: - Class Propeties

    var mapView: MKMapView!
    var placeMark: Model!
    var arrayOfAnotation = [MKPointAnnotation]()
    let calloutView = BezierView()

    override func viewDidLoad() {
        super.viewDidLoad()
        mapView = MKMapView()
        layuot()
        mapView.delegate = self
        if placeMark != nil {
            setPlaceMark(model: placeMark)
        }
    }

    func layuot() {
        view.addSubview(mapView)
        mapView.snp.makeConstraints { make in
            make.top.equalTo(view.snp.top)
            make.leading.equalTo(view.snp.leading)
            make.trailing.equalTo(view.snp.trailing)
            make.bottom.equalTo(view.snp.bottom)
        }
    }
    //MARK: - Class Methods

    func setPlaceMark(model: Model) {
        let annotation = MKPointAnnotation()
            annotation.coordinate = CLLocationCoordinate2D(latitude: model.lat, longitude: model.lon)
        annotation.title = model.id
        annotation.subtitle = "\(model.heading)"
        arrayOfAnotation.append(annotation)
        mapView.addAnnotation(annotation)
    }
}
    // MARK: - MKMap Delegate implementations

extension CoordinatesViewController: MKMapViewDelegate {
        
        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            if (annotation is MKUserLocation) {
                return nil
            }else {
                let reuseIdentifier = "pin"
                var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseIdentifier)
                if annotationView == nil {
                    annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseIdentifier)
                } else {
                    annotationView?.annotation = annotation
                }
                annotationView?.image = UIImage(systemName: "mappin.and.ellipse")
                return annotationView
            }

        }
        
        func mapView(_ mapView: MKMapView, didAdd views: [MKAnnotationView]){
            for view in views {
                view.canShowCallout = false
            }
        }
        
        func mapView(_ mapView: MKMapView,didSelect view: MKAnnotationView) {
                    if view.annotation is MKUserLocation
            {
                return
            }
            guard let id = view.annotation!.title else {return}
            guard let state = view.annotation!.subtitle else {return}
            guard let ids = id else {return}
            guard let states = state else {return}
            calloutView.msgLabel.text = "id - \(ids)"
            calloutView.stateLabel.text = "heading - \(states)"
            calloutView.bubbleDirection = .right
            calloutView.bubbleRadiusMultiplier = 0.5
            calloutView.manageBubbleView(view: view)
            mapView.setCenter((view.annotation?.coordinate)!, animated: true)
        }
        
        func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
            calloutView.removeFromSuperview()
        }
}
