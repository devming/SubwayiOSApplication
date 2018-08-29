//
//  MainViewController.swift
//  GaongilroMobile
//
//  Created by Minki on 2017. 12. 23..
//  Copyright © 2017년 devming. All rights reserved.
//
import UIKit
import MTBBarcodeScanner
import Alamofire
import SwiftyJSON
import Alamofire_SwiftyJSON

class MainViewController: UIViewController {
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var previewView: UIView!
    @IBOutlet weak var departureLabel: UILabel!
    @IBOutlet weak var destinationLabel: UILabel!
    @IBOutlet weak var leftImage: UIImageView!
    @IBOutlet weak var rightImage: UIImageView!
    @IBOutlet weak var cameraEnablingButton: UIButton!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    var scanner: MTBBarcodeScanner?
    var destinationStationName: String = ""
    var shortestPathInfo: Shortest?
    var onOffFlag = true
    let searchController = UISearchController(searchResultsController: nil)
    
    @IBAction func onOffTapped(_ sender: Any) {
        self.onOffFlag = toggleScanning(flag: self.onOffFlag)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup the Search Controller
        self.searchController.searchResultsUpdater = self
        self.searchController.obscuresBackgroundDuringPresentation = false
        self.searchController.searchBar.placeholder = "검색"
        navigationItem.searchController = self.searchController
        definesPresentationContext = true
        
        self.scanner = MTBBarcodeScanner(previewView: self.previewView)
        self.destinationLabel.text = "To: \(self.destinationStationName)"
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        guard let scanner = self.scanner else {
            return super.viewWillDisappear(animated)
        }
        
        if scanner.isScanning() {
            scanner.stopScanning()
        }
    }
}

extension MainViewController: UISearchBarDelegate {
    
}

extension MainViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        
    }
}

extension MainViewController {
    func createSearchBar() {
        // Setup the Search Controller
        self.searchController.searchResultsUpdater = self
        self.searchController.obscuresBackgroundDuringPresentation = false
        self.searchController.searchBar.placeholder = "Enter your destination here!"
        navigationItem.searchController = self.searchController
        definesPresentationContext = true
        self.searchController.searchBar.delegate = self
        
//        let searchBar = UISearchBar()
//        searchBar.showsCancelButton = false
//        searchBar.placeholder = "Enter your destination here!"
//        searchBar.delegate = self
//        self.navigationItem.titleView = searchBar
    }
    
    func startIndicator() {
        DispatchQueue.main.async { [weak self] in
            self?.activityIndicator.startAnimating()
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
        }
    }
    
    func stopIndicator() {
        DispatchQueue.main.async { [weak self] in
            self?.cameraEnablingButton.isHidden = false
            self?.descriptionLabel.isHidden = false
            self?.scanner?.stopScanning()
            self?.activityIndicator.stopAnimating()
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
        }
    }
    
    func showConfirmationAlert(alertTitle title: String, alertMessage message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(action)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func toggleScanning(flag: Bool) -> Bool {
        if flag {
            self.cameraEnablingButton.isHidden = true
            scanning()
        } else {
            self.cameraEnablingButton.isHidden = false
            self.scanner?.stopScanning()
        }
        self.descriptionLabel.isHidden = self.cameraEnablingButton.isHidden
        return !flag
    }
    
    func getJsonData() {
        if let assets = NSDataAsset(name: "subway", bundle: Bundle.main), let lines = try? JSONDecoder().decode(SubwayLine.self, from: assets.data) {
            SubwayManager.shared = lines
        }
    }
    
    func setDestinationLabel(destinationStationName name: String) {
        self.destinationStationName = name
    }
    
    func scanning() {
        MTBBarcodeScanner.requestCameraPermission(success: { [weak self] success in
            if !success {
                self?.showConfirmationAlert(alertTitle: "Scanning Unavailable", alertMessage: "This app does not have permission to access the camera")
                return
            }
            
            do {
                try self?.scanner?.startScanning { [weak self] codes in
                    guard let `self` = self, let code = codes?.first else {
                        return
                    }
                    guard let urlValue = code.stringValue else {
                        return
                    }
                    let urlDestination = "\(urlValue)/\(self.destinationStationName)"
                    guard let encodedUrl = urlDestination.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed),
                        let url = URL(string: encodedUrl) else {
                            return
                    }
                    
                    self.startIndicator()
                    self.onOffFlag = self.toggleScanning(flag: self.onOffFlag)
                    
                    print("valid url")
                    Alamofire.request(url).responseJSON { [weak self] response in
                        
                        guard let `self` = self else {
                            return
                        }
                        
                        guard !response.result.isSuccess, let value = response.result.value else {
                            self.showConfirmationAlert(alertTitle: "Error", alertMessage: "Network Error")
                            self.stopIndicator()
                            return
                        }
                        
                        let json = JSON(value)
                        let stationName = json["stationName"].stringValue
                        guard let direction = Shortest.Direction(rawValue: json["direction"].stringValue) else {
                            self.showConfirmationAlert(alertTitle: "Error", alertMessage: "Direction Parsing Error")
                            self.stopIndicator()
                            return
                        }
                        
                        self.shortestPathInfo = Shortest(startStation: stationName, direction: direction)
                        guard let toGo = self.shortestPathInfo else {
                            self.showConfirmationAlert(alertTitle: "Error", alertMessage: "toGo is nil")
                            self.stopIndicator()
                            return
                        }
                        
                        DispatchQueue.main.async { [weak self] in
                            self?.departureLabel.text = "From: \(toGo.startStation)"
                            switch self?.shortestPathInfo?.direction {
                            case .LEFT?:
                                self?.leftImage.image = UIImage(named: "ic_red_left")
                                self?.rightImage.image = UIImage(named: "ic_gray_right")
                            case .RIGHT?:
                                self?.leftImage.image = UIImage(named: "ic_gray_left")
                                self?.rightImage.image = UIImage(named: "ic_red_right")
                            default:
                                break
                            }
                        }
                        
                        self.stopIndicator()
                    }
                }
            } catch {
                self?.showConfirmationAlert(alertTitle: "Error", alertMessage: "Unable to start scanning")
            }
        })
    }
}
