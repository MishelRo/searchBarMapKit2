//
//  SceneDelegate.swift
//  searchBar
//
//  Created by User on 20.10.2021.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let _ = (scene as? UIWindowScene) else { return }
        guard let WS = (scene as? UIWindowScene) else { return }
        self.window = UIWindow(frame: WS.coordinateSpace.bounds)
        window?.windowScene = WS
        window?.rootViewController = MainStart.getNCController(controller: .tabbar)
        window?.makeKeyAndVisible()
    }
}

