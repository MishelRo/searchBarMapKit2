//
//  GetPointViewControlller.swift
//  searchBar
//
//  Created by User on 02.11.2021.
//

import UIKit
import MapKit
import CoreLocation
class GetPointViewControlller: UIViewController, CLLocationManagerDelegate, UIGestureRecognizerDelegate, MKMapViewDelegate, AllertViewControllerDelegate {

    var mapView: MKMapView!

    var lat:  CLLocationDegrees!
    var lon:  CLLocationDegrees!
    var stackView: UIStackView!
    var clicked = false
    var firstLaunchView = true
    var constraint = 340.0
    let locationManager = CLLocationManager()
    var alert: AllertViewController!

 
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView = MKMapView()
        mapView.delegate = self
        heightConfigure()
        stackView = UIStackView()
        alert = AllertViewController()
        alert.delegate = self
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
        view.backgroundColor = .white
        mapView.mapType = .hybrid
        layOut()
        addMapTrackingButton()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }
  
    @IBAction func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue { 
            if self.view.frame.origin.y == 0 { 
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }

    @IBAction func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
 
    
    func heightConfigure() {
        if UIScreen.isPhone7() {
            constraint = 295
        }
    }
    
    func layOut() {
        view.addSubview(mapView)
        mapView.snp.makeConstraints { make in
            make.leading.equalTo(view.snp.leading)
            make.top.equalTo(view.snp.top)
            make.trailing.equalTo(view.snp.trailing)
            make.bottom.equalTo(view.snp.bottom).offset(-constraint)
        }
        view.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.height.equalTo(constraint - 7)
            make.leading.equalTo(view.snp.leading)
            make.trailing.equalTo(view.snp.trailing)
            make.bottom.equalTo(view.snp.bottom)
        }
    }
    
    func addMapTrackingButton() {
        let image = UIImage(systemName: "arrowtriangle.down.fill")
        let button = UIButton()
        button.setImage(image, for: .normal)
        button.backgroundColor = .clear
        mapView.addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        let horizontalConstraint = button.centerXAnchor.constraint(equalTo: mapView.centerXAnchor)
        let verticalConstraint = button.centerYAnchor.constraint(equalTo: mapView.centerYAnchor)
        let widthConstraint = button.widthAnchor.constraint(equalToConstant: 20)
        let heightConstraint = button.heightAnchor.constraint(equalToConstant: 20)
        view.addConstraints([horizontalConstraint, verticalConstraint, widthConstraint, heightConstraint])
    }
    
    func updateVal(val: Int) {
        let view = TwoLabelsDetailButtonView()
        GeoLocations().geoData(lat: mapView.centerCoordinate.latitude, lon: mapView.centerCoordinate.longitude) { [unowned self] placeMark in
            view.changeConfigure(lat: mapView.centerCoordinate.latitude, long: mapView.centerCoordinate.longitude, state: "\(val)", placeMark: "\(placeMark.country ?? ""), \(placeMark.administrativeArea ?? ""), \(placeMark.name ?? "")" ) {
            self.alert.delegate = self
              self.alert.modalPresentationStyle = .automatic
              self.present(self.alert, animated: true, completion: nil)
        }
        stackView.removeSubviews()
                           [view].forEach { stackView.addArrangedSubview($0) }
                           self.view.layoutIfNeeded()
               clicked = true
        }
    }
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
           let center = mapView.centerCoordinate
        GeoLocations().geoData(lat: center.latitude, lon: center.longitude) { [unowned self] placeMark in
            if clicked == false {
                let view = TwoLabelsDetailButtonView()
                view.configure(lat: center.latitude, long: center.longitude, placeMarkName: "\(placeMark.country ?? ""), \(placeMark.administrativeArea ?? ""), \(placeMark.name ?? "")") {
                    self.present(alert, animated: true, completion: nil)
                }
                            stackView.removeSubviews()
                            [view].forEach { stackView.addArrangedSubview($0) }
                            self.view.layoutIfNeeded()
                clicked = true
            }
        }
      }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if clicked {
            clicked = false
        }
    }
}


