//
//  ViewController.swift
//  searchBar
//
//  Created by User on 20.10.2021.
//

import UIKit
import SnapKit
import CoreData
import MapKit

class MapViewController: UIViewController {
    
    //MARK: - Class Propeties
    
    var calloutView: BezierView!
    var arrayOfPoint: [Model]!
    var sortedArray: [Model]!
    var addButton: UIButton!
    var reuseIdentifier: String!
    var stackView: UIStackView!
    var constraint = Int(Constants.getStatus(status: .height))
    var alert: AllertViewController!
    var sortedByState = false
    var sortedById = false
    var cell: TwoLabelsDetailButtonView!
    
    var activityIndicator: UIActivityIndicatorView!
    var searchController : UISearchController!
    var sortByState: UIBarButtonItem!
    var model: MapViewModelProtocol!
    var sortByid: UIBarButtonItem!
    var mapView: MKMapView!
    var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var searchResultsController: NSFetchedResultsController<NSFetchRequestResult>?
    
    var fetchedResultsController: NSFetchedResultsController<NSFetchRequestResult> {
        let workFetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "DataCD")
        let primarySortDescriptor = NSSortDescriptor(key: "id", ascending: true)
        workFetchRequest.sortDescriptors = [primarySortDescriptor]
        let frc = NSFetchedResultsController(
            fetchRequest: workFetchRequest,
            managedObjectContext: context,
            sectionNameKeyPath: "createdDate",
            cacheName: nil)
        frc.delegate = self
        return frc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        heightConfigure()
        cell = TwoLabelsDetailButtonView()
        cell.delegate = self
        alert = AllertViewController()
        alert.delegate = self
        calloutView = BezierView()
        stackView = UIStackView()
        sortedArray = [Model]()
        arrayOfPoint = [Model]()
        mapView = MKMapView()
        mapView.mapType = .hybrid
        mapView.showsCompass = true
        mapView.showsScale = true
        mapView.delegate = self
        model = MapViewModel()
        addButton = UIButton()
        activityIndicator = UIActivityIndicatorView()
        activityIndicator.startAnimating()
        layuot()
        searchControllerConfigure()
        setupPoints()
        barButtonConfig()
        reuseIdentifier = Constants.getStatus(status: .reuseIdentifier)
        mapView.register(AnnotationView.self,
                         forAnnotationViewWithReuseIdentifier: MKMapViewDefaultClusterAnnotationViewReuseIdentifier)
    }
    
    func barButtonConfig() {
        let button = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(searchCoordinate))
        navigationItem.rightBarButtonItem = button
    }
    
    @objc func searchCoordinate() {
        
       UIAlertController.setNewCoordinate { [unowned self] points in
           let annotation = MKPointAnnotation()
           annotation.coordinate = CLLocationCoordinate2D(latitude: Double(points.lat)!, longitude: Double(points.lon)!)
           self.mapView.addAnnotation(annotation)
           self.model.savePoint(points: points)
           self.mapView.camera = MKMapCamera(lookingAtCenter: annotation.coordinate,
                                             fromDistance: 4000000,
                                             pitch: 3,
                                             heading: .greatestFiniteMagnitude)
       } alertCompletion: { controller in
            self.present(controller, animated: true, completion: nil)
        }
    }

    
    func heightConfigure() {
        if UIScreen.isPhone7() {
            constraint = Int(Double(Constants.getStatus(status: .hightForIphone7))!)
        }
    }
    
    func stackViewLayOutConfigure() {
        self.view.addSubview(stackView)
        self.stackView.snp.makeConstraints { make in
            make.height.equalTo(constraint! - 14)
            make.leading.equalTo(view.snp.leading)
            make.trailing.equalTo(view.snp.trailing)
            make.bottom.equalTo(view.snp.bottom)
        }
    }
    
    func changePoint(lat: Double, long: Double) {
        stackViewLayOutConfigure()
        GeoLocations().geoData(lat: lat, lon: long) { [unowned self] placeMarks in
            let views = TwoLabelsDetailButtonView()
            views.configure(lat: lat,
                            long: long,
                            placeMarkName: "\(placeMarks.country ?? "")" +
                            "\(placeMarks.administrativeArea ?? "")" +
                            " \(placeMarks.name ?? "")") {
                present(self.alert, animated: true, completion: nil)
            }
            stackView.removeSubviews()
            [views].forEach { stackView.addArrangedSubview($0) }
            view.layoutIfNeeded()
        }
    }
    
    private  func layuot() {
        view.addSubview(mapView)
        mapView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.equalTo(view.snp.leading)
            make.trailing.equalTo(view.snp.trailing)
            make.bottom.equalTo(view.snp.bottom)
        }
        view.addSubview(activityIndicator)
        activityIndicator.snp.makeConstraints { make in
            make.centerX.equalTo(view.snp.centerX)
            make.centerY.equalTo(view.snp.centerY)
        }
        view.addSubview(addButton)
        addButton.snp.makeConstraints { make in
            make.height.equalTo(40)
            make.width.equalTo(40)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-20)
            make.trailing.equalTo(view.snp.trailing).offset(-30)
            addButton.backgroundColor = .green
            addButton.layer.cornerRadius = 20
            addButton.setTitle("+", for: .normal)
        }
        addButton.addTarget(self, action: #selector(addPoint), for: .touchUpInside)
        saveData()
    }
    @objc func addPoint() {
        MainStart.present(view: self, controller: .getPointController)
    }
    
    
    //MARK: - SearchBar Methods
    
    private func searchControllerConfigure() {
        self.searchController = UISearchController()
        self.searchController.searchResultsUpdater = self
        self.searchController.delegate = self
        self.searchController.searchBar.delegate = self
        self.searchController.searchBar.text = .none
        self.searchController.searchBar.showsBookmarkButton = true
        self.searchController.searchBar.setImage(UIImage(named: "filter"), for: .bookmark, state: .normal)
        self.searchController.hidesNavigationBarDuringPresentation = false
        self.navigationItem.titleView = searchController.searchBar
        self.definesPresentationContext = true
    }
    
    private func setupPoints() {
        model.setPoints(points: getSortedArray()) { points in
            self.mapView.addAnnotation(points)
        }
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        if searchController.isActive {
            searchController.searchBar.showsBookmarkButton = false
        } else {
            searchController.searchBar.showsBookmarkButton = true
        }
        guard let texts = searchController.searchBar.text else {return}
        guard let _ = Int(texts) else {
            switch texts {
            case Constants.getStatus(status: .alarm) :
                reuseIdentifier =  Constants.getStatus(status: .alarm)
                model.clean { point in
                    self.mapView.removeAnnotation(point)
                }
                model.sorted(state: 0) { points in
                    self.mapView.addAnnotation(points)
                }
            case  Constants.getStatus(status: .stop):
                reuseIdentifier = Constants.getStatus(status: .stop)
                model.clean { point in
                    self.mapView.removeAnnotation(point)
                }
                model.sorted(state: 1) { points in
                    self.mapView.addAnnotation(points)
                }
            case Constants.getStatus(status: .movement):
                reuseIdentifier = Constants.getStatus(status: .movement)
                model.clean { point in
                    self.mapView.removeAnnotation(point)
                }
                model.sorted(state: 2) { points in
                    self.mapView.addAnnotation(points)
                }
            case Constants.getStatus(status: .parking):
                reuseIdentifier = Constants.getStatus(status: .parking)
                model.clean { point in
                    self.mapView.removeAnnotation(point)
                }
                model.sorted(state: 3) { points in
                    self.mapView.addAnnotation(points)
                }
            default:
                break
            }
            ;return }
        self.searchController.searchBar.setImage(UIImage(named: "filter"), for: .bookmark, state: .normal)
        let text1 = searchController.searchBar.text ?? ""
        guard text1.count >= 0 else {return}
        model.clean { item in
            self.mapView.removeAnnotation(item)
        }
        model.searchBar(searchBar: searchController.searchBar, textDidChange: text1) { arrayOfSorted in
            self.model.setPoints(points: arrayOfSorted) { annotation in
                self.mapView.addAnnotation(annotation)
            }
        }
    }
    //MARK: - Data Methods
    
    private func getSortedArray() -> [Model] {
        self.model.getData { [self] arrayOfCoordinates in
            self.arrayOfPoint = arrayOfCoordinates
            self.activityIndicator.isHidden = true
            CoreDataManager.shared.loadOnePoint { point in
                self.sortedArray.append(point)
            }
            for item in arrayOfCoordinates{
                if sortedArray.count < 100 {
                    sortedArray.append( item)
                }
            }
        }
        return sortedArray
    }
    
    private func saveData() {
        let userDef = UserDefaults()
        if userDef.bool(forKey: "FirstLaunch") == false{
            model.getDataToCoreData {
                self.activityIndicator.stopAnimating()
                self.activityIndicator.isHidden = true
                userDef.set(true, forKey: "FirstLaunch")
                self.setupPoints()
            }
        }
    }
}
// MARK: - MKMap Delegate, UISearchBarDelegate, NSFetchedResultsControllerDelegate, implementations
extension MapViewController: UISearchResultsUpdating,NSFetchedResultsControllerDelegate,
                             UISearchControllerDelegate,
                             UISearchBarDelegate {
    
    func searchBarBookmarkButtonClicked(_ searchBar: UISearchBar) {
        present(alert, animated: true, completion: nil)
    }
}

extension MapViewController: AllertViewControllerDelegate{
    func updateVal(val: Int) {
        self.searchController.searchBar.setImage(UIImage(named: "selectedFilter"), for: .bookmark, state: .normal)
        
        switch val {
        case Int(Constants.getStatus(status: .stateZero)):
            searchController.searchBar.text = Constants.getStatus(status: .alarm)
        case Int(Constants.getStatus(status: .stateOne)):
            searchController.searchBar.text = Constants.getStatus(status: .stop)
        case Int(Constants.getStatus(status: .stateTwo)):
            searchController.searchBar.text = Constants.getStatus(status: .movement)
        case Int(Constants.getStatus(status: .stateThree)):
            searchController.searchBar.text = Constants.getStatus(status: .parking)
        default:
            break
        }
    }
}

extension MapViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        if annotation is MKUserLocation {
            return nil
        }else {
            var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseIdentifier)
            if annotationView == nil {
                annotationView = AnnotationView(annotation: annotation, reuseIdentifier: reuseIdentifier)
            } else { annotationView?.annotation = annotation }
            return annotationView
        }
    }
    
    func mapView(_ mapView: MKMapView, didAdd views: [MKAnnotationView]){
        for view in views {
            view.canShowCallout = false
        }
    }
    
    func mapView(_ mapView: MKMapView,didSelect view: MKAnnotationView) {
        if view.annotation is MKUserLocation {return}
        guard let id = view.annotation!.title else {return}
        guard let state = view.annotation!.subtitle else {return}
        guard let ids = id else {return}
        guard let states = state else {return}
        calloutView.msgLabel.text = " \(ids)"
        calloutView.stateLabel.text = " \(states)"
        calloutView.bubbleDirection = .right
        calloutView.bubbleRadiusMultiplier = 0.5
        calloutView.manageBubbleView(view: view)
        stackView.isHidden = false
        changePoint(lat: (view.annotation?.coordinate.latitude)!, long: (view.annotation?.coordinate.longitude)!)
        mapView.setCenter((view.annotation?.coordinate)!, animated: true)
    }
    
    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        calloutView.removeFromSuperview()
        stackView.isHidden = true
    }
}
extension MapViewController: TwoLabelsDetailButtonProtocol{
    func updateCoordinate(lat: Double, long: Double) {
        print("change data in coredata")
    }
}





