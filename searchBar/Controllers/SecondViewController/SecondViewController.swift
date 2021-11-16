//
//  SecondViewController.swift
//  searchBar
//
//  Created by User on 20.10.2021.
//

import UIKit
import SnapKit
import SwiftyJSON
import CoreData


class SecondViewController: UIViewController {
    
    //MARK: - Class Propeties
    
    var tableView: UITableView!
    var model: SecondViewControllerModel!
    
    var sortByid: UIBarButtonItem!
    var sortByState: UIBarButtonItem!
    var searchController: UISearchController!
    
    var alert: AllertViewController!
    var coordinates: [Model]!
    var filteredWorkItems: [Model]!
    var arrayOfAllElements: [Model]!
    var arrayOfDeletedCoordinates: [Model]!
    
    var sortedById: Bool!
    var sortedByState: Bool!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        alert.delegate = self
        tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        alert = AllertViewController()
        model = SecondViewControllerModel()
        searchControllerConfigure()
        loadData()
        layout()
        tableView.register(UINib(nibName: TableViewCell.cellName , bundle: nil),
                           forCellReuseIdentifier: TableViewCell.reuseId)
    }
    
    func loadData() {
        model.getData { coordinatres in
            let filtrredArray = self.filtredCoordinates(array: coordinatres)
            self.arrayOfAllElements = filtrredArray
            self.coordinates = filtrredArray
            self.tableView.reloadData()
        }
    }
    
    private func layout() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.equalTo(view.snp.top)
            make.bottom.equalTo(view.snp.bottom)
            make.leading.equalTo(view.snp.leading)
            make.trailing.equalTo(view.snp.trailing)
        }
    }
    
    //MARK: - SearchMethods
    
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
    
    func updateSearchResults(for searchController: UISearchController){
        guard let texts = searchController.searchBar.text else {return}
        guard let _ = Int(texts) else {
            sortedById = false
            sortedByState = true
            switch texts {
            case Constants.getStatus(status: .alarm):
                searchBar(searchBar: searchController.searchBar,
                          textDidChange: Constants.getStatus(status: .stateZero)) { [unowned self] arrayOfSorted in
                    coordinates = [Model]()
                    coordinates = arrayOfSorted
                    tableView.reloadData()
                }
            case Constants.getStatus(status: .stop):
                searchBar(searchBar: searchController.searchBar,
                          textDidChange: Constants.getStatus(status: .stateOne)) { [unowned self] arrayOfSorted in
                    coordinates = [Model]()
                    coordinates = arrayOfSorted
                    tableView.reloadData()
                }
            case Constants.getStatus(status: .movement):
                searchBar(searchBar: searchController.searchBar,
                          textDidChange: Constants.getStatus(status: .stateTwo)) { [unowned self] arrayOfSorted in
                    coordinates = [Model]()
                    coordinates = arrayOfSorted
                    tableView.reloadData()
                }
            case Constants.getStatus(status: .parking):
                searchBar(searchBar: searchController.searchBar,
                          textDidChange: Constants.getStatus(status: .stateThree)) { [unowned self] arrayOfSorted in
                    coordinates = [Model]()
                    coordinates = arrayOfSorted
                    tableView.reloadData()
                }
            default:
                break
            } ;return }
        sortedById = true
        sortedByState = false
        let text = searchController.searchBar.text ?? ""
        guard text.count >= 1 else {
            self.coordinates = arrayOfAllElements
            tableView.reloadData(); return
        }
        searchBar(searchBar: searchController.searchBar, textDidChange: text) { [weak self] arrayOfSorted in
            self?.coordinates = [Model]()
            self?.coordinates = arrayOfSorted
            self?.tableView.reloadData()
        }
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String, complession: @escaping([Model])->()) {
        reloaInputdData()
        if sortedById {
            self.filteredWorkItems = self.coordinates.filter({( work: Model) -> Bool in
                let stringMatch = work.id.range(of: searchText)
                return stringMatch != nil
            })
            complession(filteredWorkItems)
        }
        if sortedByState {
            self.filteredWorkItems = self.coordinates.filter({( work: Model) -> Bool in
                let stage = "\(work.state)"
                let stringMatch = stage.range(of: searchText)
                return stringMatch != nil
            })
            complession(filteredWorkItems)
        }
    }
    
    //MARK: - Deleted And Sorted Methods
    func ignoredCoordinates(id: Int){
        DeletedManager().addToIgnore(id: id)
        tableView.reloadData()
    }
    
    func reloaInputdData() {
        model.getData { [unowned self] coordinatres in
            arrayOfAllElements = [Model]()
            coordinates = [Model]()
            let filtrredArray = self.filtredCoordinates(array: coordinatres)
            arrayOfAllElements = filtrredArray
            coordinates = filtrredArray
            tableView.reloadData()
        }
    }
    
    func filtredCoordinates(array: [Model])-> [Model]{
        let filter = DeletedManager().arrayOfDeletedIds()
        let filtered = array.filter{ !filter.contains(Int($0.id)!) }
        return filtered
    }
    
}
// MARK: - UITableViewDelegate, UITableViewDataSource, implementation
extension SecondViewController: UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating,
                                NSFetchedResultsControllerDelegate,
                                UISearchControllerDelegate,
                                UISearchBarDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        coordinates.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCell.reuseId,
                                                 for: indexPath) as! TableViewCell
        let currentCellData = coordinates[indexPath.row]
        cell.cellConfigure(model: currentCellData)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let currentCellData = coordinates[indexPath.row]
        let controller = CoordinatesViewController()
        controller.placeMark = currentCellData
        controller.viewDidLoad()
        navigationController?.pushViewController(controller, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        50
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    func tableView(_ tableView: UITableView,
                   commit editingStyle: UITableViewCell.EditingStyle,
                   forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            let element = coordinates[indexPath.row]
            ignoredCoordinates(id: Int(element.id)!)
            reloaInputdData()
            tableView.reloadData()
        }
    }
}
extension SecondViewController: AllertViewControllerDelegate{
    func updateVal(val: Int) {
        self.searchController.searchBar.setImage(UIImage(named: "selectedFilter"), for: .bookmark, state: .normal)
        switch val {
        case Int(Constants.getStatus(status: .stateZero)):
            searchController.searchBar.text = Constants.getStatus(status: .alarm)
        case  Int(Constants.getStatus(status: .stateOne)):
            searchController.searchBar.text = Constants.getStatus(status: .stop)
        case  Int(Constants.getStatus(status: .stateTwo)):
            searchController.searchBar.text = Constants.getStatus(status: .movement)
        case  Int(Constants.getStatus(status: .stateThree)):
            searchController.searchBar.text = Constants.getStatus(status: .parking)
        default:
            break
        }
    }
    func searchBarBookmarkButtonClicked(_ searchBar: UISearchBar) {
        present(alert, animated: true, completion: nil)
    }
}
