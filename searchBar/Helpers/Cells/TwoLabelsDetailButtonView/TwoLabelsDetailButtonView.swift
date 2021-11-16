//
//  TwoLabelsDetailButtonView.swift
//  moyaTests
//
//  Created by User on 15.09.2021.
//

protocol TwoLabelsDetailButtonProtocol {
    func updateCoordinate(lat: Double, long: Double)
}


import UIKit
import MapKit
import SnapKit
class TwoLabelsDetailButtonView: NibLoadableView, UITextFieldDelegate {
    
    @IBOutlet weak var latLabel: UITextField!
    @IBOutlet weak var longLabel: UITextField!
    @IBOutlet weak var stateLabel: UILabel!
    @IBOutlet weak var chooseButton: UIButton!
    @IBOutlet weak var savebutton: UIButton!
    @IBOutlet weak var headingTextField: UITextField!
    @IBOutlet weak var stackViewChooseView: UIStackView!
    @IBOutlet weak var pointName: UILabel!
    
    var model: TwoLabelDetailModel!
    var delegate: TwoLabelsDetailButtonProtocol!

    var launchFromMain = false
    var deletedLat = CLLocationDegrees()
    var deletedLon = CLLocationDegrees()
    let tableView = UITableView()
    var chooseViewIsHidden = true
    var lat = CLLocationDegrees()
    var lon = CLLocationDegrees()
    var heating = 0
    
    var complessionAlert: (()->())!
    static var state = 0 {
        didSet {
            TwoLabelsDetailButtonView().stateLabel.text = "\(oldValue)"
        }
    }
    static var complessionState: Int! {
        didSet{
        }
    }
    
    func heightConfigure() {
        if UIScreen.isPhone7() {
            latLabel.font = UIFont(name: "System", size: 5)
            longLabel.font = UIFont(name: "System", size: 5)
        }
    }
    
    @IBAction func saveAction(_ sender: Any) {
        if launchFromMain == false {
            if let headTF = headingTextField.text, headTF != ""{
                guard let head = Int(headTF) else {
                    headingTextField.text = "enter correct value";
                    return}
                self.heating = head
                let newPoint = Model(id: "\(lat + lon)",
                                     lat: lat,
                                     lon: lon,
                                     state: TwoLabelsDetailButtonView.state,
                                     heading: heating)
                model.setPoint(point: newPoint)
                
            } else if headingTextField.text == "" {
                headingTextField.text = "enter value"
            }
        } else {
            let newPoint = Model(id: "\(lat + lon)",
                                 lat: lat,
                                 lon: lon,
                                 state: TwoLabelsDetailButtonView.state,
                                 heading: heating)
            model.setPoint(point: newPoint)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>,
                               with event: UIEvent?) {
        tableView.isHidden = true
    }
    
    func changeConfigure(lat: CLLocationDegrees,
                         long: CLLocationDegrees,
                         state: String, placeMark: String, complession: @escaping (()->())) {
        self.lat = lat
        lon = long
        launchFromMain = true
        deletedLat = lat
        deletedLon = long
        latLabel.text = "\(lat)" + " "
        longLabel.text = "\(long)" + " "
        pointName.text = placeMark
        complessionAlert = complession
        delegate = MapViewController()
        switch state {
        case Constants.getStatus(status: .stateZero) :
            stateLabel.text = Constants.getStatus(status: .alarm)
        case Constants.getStatus(status: .stateOne):
            stateLabel.text = Constants.getStatus(status: .stop)
        case Constants.getStatus(status: .stateTwo):
            stateLabel.text = Constants.getStatus(status: .movement)
        case Constants.getStatus(status: .stateThree):
            stateLabel.text = Constants.getStatus(status: .parking)
        default:
            break
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configure(lat: CLLocationDegrees,
                   long: CLLocationDegrees,
                   placeMarkName: String,
                   complession: @escaping (()->()))  {
        self.lat = lat
        lon = long
        latLabel.text = "\(lat)"
        longLabel.text = "\(long)"
        heightConfigure()
        print(placeMarkName)
        complessionAlert = complession
        pointName.text = placeMarkName
        delegate = MapViewController()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.headingTextField.delegate = self
        savebutton.layer.cornerRadius = 10
        latLabel.delegate = self
        longLabel.delegate = self
        stackViewChooseView.layer.cornerRadius = 5
        stackViewChooseView.borderWidth = 0.1
        stackViewChooseView.backgroundColor = .white
        latLabel.backgroundColor = .clear
        longLabel.backgroundColor = .clear
        stateLabel.backgroundColor = .white
        chooseButton.backgroundColor = .white
        let tap = UITapGestureRecognizer(target: self,
                                         action: #selector(self.tabLabel))
        let tap2 = UITapGestureRecognizer(target: self,
                                          action: #selector(self.tabLabel))
        stateLabel.isUserInteractionEnabled = true
        stateLabel.addGestureRecognizer(tap)
        chooseButton.addGestureRecognizer(tap2)
        latLabel.addTarget(self, action: #selector(latChange(_:)),
                           for: UIControl.Event.editingChanged)
        longLabel.addTarget(self, action: #selector(longChange(_:)),
                            for: UIControl.Event.editingChanged)
        model = TwoLabelDetailModel()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.endEditing(true)
        return false
    }
    
    @objc func latChange(_ textField: UITextField) {
        guard let newlat = Double(latLabel.text!) else {return}
        lat = newlat
        delegate.updateCoordinate(lat: lat, long: lon)
    }
    @objc func longChange(_ textField: UITextField) {
        guard let newlong = Double(longLabel.text!) else {return}
        lon = newlong
        delegate.updateCoordinate(lat: lat, long: lon)
    }
    
    @objc func tabLabel() {
            complessionAlert()
    }
}
extension TwoLabelsDetailButtonView: AllertViewControllerDelegate {
    func updateVal(val: Int) {
        stateLabel.text = "\(val)"
    }
}
