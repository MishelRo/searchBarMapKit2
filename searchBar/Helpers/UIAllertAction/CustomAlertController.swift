//
//  UiAllertAction.swift
//  searchBar
//
//  Created by User on 03.11.2021.
//

import UIKit
import SnapKit
class  CustomAlertController: UIViewController {


    func getAllert(complession: @escaping((Int)->())) -> UIViewController{
        let actionSheetController = AllertViewController()

        return actionSheetController
    }
}
