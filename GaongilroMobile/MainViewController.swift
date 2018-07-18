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
    
    @IBOutlet var previewView: UIView!
    var scanner: MTBBarcodeScanner?
    
    @IBOutlet weak var departureLabel: UILabel!
    @IBOutlet weak var destinationLabel: UILabel!
    @IBOutlet weak var leftImage: UIImageView!
    @IBOutlet weak var rightImage: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    var destinationStationName: String = ""
    var shortestPathInfo: Shortest?
    
    var onOffFlag = true
    
    let searchController = UISearchController(searchResultsController: nil)
    
    @IBAction func onOffTapped(_ sender: Any) {
        
        if onOffFlag {
            descriptionLabel.isHidden = true
            scanning()
        } else {
            descriptionLabel.isHidden = false
            scanner?.stopScanning()
        }
        onOffFlag = !onOffFlag
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Setup the Search Controller
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "검색"
        navigationItem.searchController = searchController
        definesPresentationContext = true
        
        scanner = MTBBarcodeScanner(previewView: previewView)
        self.destinationLabel.text = "\(self.destinationStationName) (도착)"
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        guard let scanner = self.scanner else {
            return super.viewWillDisappear(animated)
        }
        
        if scanner.isScanning() {
            scanner.stopScanning()
        }
        
        super.viewWillDisappear(animated)
    }
    
    func setDestinationLabel(destinationStationName name: String) {
        self.destinationStationName = name
        
    }
    
    func scanning() {
        MTBBarcodeScanner.requestCameraPermission(success: { success in
            if success {
                do {
                    try self.scanner?.startScanning(resultBlock: { [weak self] codes in
                        guard let self1 = self else {
                            return
                        }
                        if let codes = codes {
                            for code in codes {
                                let urlValue = code.stringValue!
                                print("Found code: \(urlValue)")
                                // TODO: urlValue 로 연결 [ urlValue = /qr/{station_admin_id}/{index}/{destination_station} ]
                                let urlDestination = "\(urlValue)/\(self1.destinationStationName)"
                                print("urlDestination:\(urlDestination)")
                                let encodedUrl = urlDestination.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!
                                if let url = URL(string: encodedUrl) {
                                    
                                    DispatchQueue.main.async { [weak self] in
                                        self?.activityIndicator.startAnimating()
                                    }
                                    print("valid url")
                                    Alamofire.request(url).responseJSON(completionHandler: { [weak self] (response) in
                                        
                                        guard let self2 = self else {
                                            return
                                        }
                                        if response.result.isSuccess {
                                            if let value = response.result.value {
                                                let json = JSON(value)
                                                let stationName = json["stationName"].stringValue
                                                guard let direction = Shortest.Direction(rawValue: json["direction"].stringValue) else {
                                                    print("direction converting error")
                                                    return
                                                }
                                                
                                                self2.shortestPathInfo = Shortest(startStation: stationName, direction: direction)
                                                guard let toGo = self2.shortestPathInfo else {
                                                    print("toGo nil")
                                                    return
                                                }
                                                DispatchQueue.main.async { [weak self] in
                                                    guard let self3 = self else {
                                                        return
                                                    }
                                                    self3.departureLabel.text = "\(toGo.startStation) (출발)"
                                                    switch self3.shortestPathInfo?.direction {
                                                    case .LEFT?:
                                                        self3.leftImage.image = UIImage(named: "RedLeft")
                                                        self3.rightImage.image = UIImage(named: "GrayRight")
                                                    case .RIGHT?:
                                                        self3.leftImage.image = UIImage(named: "GrayLeft")
                                                        self3.rightImage.image = UIImage(named: "RedRight")
                                                    default:
                                                        break
                                                    }
                                                }
                                                
                                                self2.onOffFlag = false
                                                DispatchQueue.main.async { [weak self] in
                                                   
                                                    self?.descriptionLabel.isHidden = false
                                                    self?.scanner?.stopScanning()
                                                    self?.activityIndicator.stopAnimating()
                                                }
                                            }
                                        } else {
                                            print("Network ERROR")
                                            DispatchQueue.main.async { [weak self] in
                                                self?.activityIndicator.stopAnimating()
                                            }
                                        }
                                    })
                                } else {
                                    print("invalid url")
                                }
                            }
                            
                        }
                    })
                } catch {
                    let alertController = UIAlertController(title: "Unable to start scanning", message: "", preferredStyle: .alert)
                    let action = UIAlertAction(title: "OK", style: .default, handler: nil)
                    alertController.addAction(action)
                    self.present(alertController, animated: true, completion: nil)
                    NSLog("Unable to start scanning")
                }
            } else {
                let alertController = UIAlertController(title: "Scanning Unavailable", message: "This app does not have permission to access the camera", preferredStyle: .alert)
                let action = UIAlertAction(title: "OK", style: .default, handler: nil)
                alertController.addAction(action)
                self.present(alertController, animated: true, completion: nil)
            }
        })
    }
    
}

extension MainViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        
    }
    
    
}
