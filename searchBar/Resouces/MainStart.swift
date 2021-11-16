//
//  MainStart.swift
//  searchBar
//
//  Created by User on 20.10.2021.
//

import UIKit

enum returnVC {
    case mainViewController
    case tabbar
    case coordinateViewController
    case getPointController
}

extension returnVC {
    func path()-> UIViewController{
        switch self {
        case .mainViewController:
            return MapViewController()
        case .tabbar:
            return TabBar()
        case .coordinateViewController:
            return CoordinatesViewController()
        case .getPointController:
            return GetPointViewControlller()
        }
    }
}

class MainStart {
    
    static func getNCController(controller: returnVC) -> UINavigationController {
        UINavigationController(rootViewController: controller.path())
    }
    static func getController(controller: returnVC) -> UIViewController {
        controller.path()
    }
    static func present(view: UIViewController, controller: returnVC) {
        view.navigationController?.pushViewController(controller.path(), animated: true)
    }
}
