//
//  TabBar.swift
//  searchBar
//
//  Created by User on 20.10.2021.
//

import UIKit

class TabBar: UITabBarController {

    fileprivate func createNavController(for rootViewController: UIViewController,
                                                      title: String,
                                                      image: UIImage) -> UIViewController {
            let navController = UINavigationController(rootViewController: rootViewController)
            navController.tabBarItem.title = title
            navController.tabBarItem.image = image
            return navController
        }
    
    func setupVCs() {
           viewControllers = [
               createNavController(for: MapViewController(),
                                      title: NSLocalizedString("Карта", comment: ""),
                                      image: UIImage(systemName: "map")!),
               createNavController(for: SecondViewController(),
                                      title: NSLocalizedString("Список", comment: ""),
                                      image: UIImage(systemName: "list.dash")!)]
       }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        UITabBar.appearance().barTintColor = .white
        tabBar.tintColor = .label
        setupVCs()
        tabBar.backgroundColor = .white
    }
}
