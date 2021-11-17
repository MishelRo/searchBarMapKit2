//
//  AllertViewController.swift
//  searchBar
//
//  Created by User on 05.11.2021.
//

import UIKit

protocol AllertViewControllerDelegate: AnyObject {
    func updateVal(val: Int)
}




class AllertViewController: UIViewController {

    
    
    @IBOutlet weak var myView: UIView!
    @IBOutlet weak var heightConstaint: NSLayoutConstraint!
    @IBOutlet weak var collectionView: UICollectionView!
    
    weak var delegate: AllertViewControllerDelegate?

    var arrayOfText = ["тревога",
                       "отстановка",
                       "движение",
                       "парковка"]
    var arrayOfImage = ["warnings", "stop", "moveme", "parking" ]

    override func viewDidLoad() {
        super.viewDidLoad()
        heightConfigure()
        view.backgroundColor = .clear
        collectionView.layer.cornerRadius = 20
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: "AllertCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "Cells")
        myView.backgroundColor = .clear
        let tap = UITapGestureRecognizer(target: self, action: #selector(hide))
        myView.addGestureRecognizer(tap)
    }

    @objc func hide() {
        dismiss(animated: true, completion: nil)
    }
    
    
    func heightConfigure() {
        if UIScreen.isPhone7() {
            heightConstaint.constant = 200
        }
    }
    
    
}
extension AllertViewController: UICollectionViewDelegate,
                                UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cells", for: indexPath) as! AllertCollectionViewCell
        let text = "     \(arrayOfText[indexPath.row])"
        let image = arrayOfImage[indexPath.row]
        cell.config(text: text, image: image)
        return cell
    }
    
}

extension AllertViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView
                        , layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.width, height: collectionView.frame.height / 5 )
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
      
        delegate!.updateVal(val: indexPath.row)
        dismiss(animated: true, completion: nil)
    }
    
}
