//
//  MenuViewController.swift
//  GaongilroMobile
//
//  Created by Minki on 2018. 9. 28..
//  Copyright © 2018년 devming. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController {
    
    var menuList: [(String, UIImage)]?

    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.menuList = [(String, UIImage)]()
        self.menuList?.append(("지하철역", UIImage(named: "ic_subway")!))
        self.menuList?.append(("주변 버스", UIImage(named: "ic_bus")!))
        self.menuList?.append(("식당", UIImage(named: "ic_fork")!))
        self.menuList?.append(("화장실", UIImage(named: "ic_toilet")!))
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        if let cell = sender as? MenuCollectionViewCell, let indexPath = self.collectionView.indexPath(for: cell) {
            if indexPath.item != 0 {
                showConfirmationAlert(alertTitle: "Coming Soon", alertMessage: "준비중입니다.")
            }
        }
    }
}

extension MenuViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let menuList = self.menuList else {
            return 0
        }
        return menuList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MenuCollectionViewCell.cellName, for: indexPath) as? MenuCollectionViewCell else {
            return UICollectionViewCell()
        }
        if let menuList = self.menuList {
            cell.menuLabel.text = menuList[indexPath.item].0
            cell.menuImageView.image = menuList[indexPath.item].1
        }
        cell.layer.cornerRadius = 10
        cell.layer.borderColor = UIColor.black.cgColor
        cell.layer.borderWidth = 2
        return cell
    }
}

extension MenuViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width: CGFloat = collectionView.frame.width / 2 - 30
        return CGSize(width: width, height: width)
    }
}

extension MenuViewController {
    func showConfirmationAlert(alertTitle title: String, alertMessage message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(action)
        self.present(alertController, animated: true, completion: nil)
    }
}
