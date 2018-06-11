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
    
    var qrScanAllowed = true
    
    @IBOutlet var previewView: UIView!
    var scanner: MTBBarcodeScanner?
    
    @IBOutlet weak var departureLabel: UILabel!
    @IBOutlet weak var destinationLabel: UILabel!
    @IBOutlet weak var leftImage: UIImageView!
    @IBOutlet weak var rightImage: UIImageView!
    
    var destinationStationName: String = ""
    var toGo: Shortest?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scanner = MTBBarcodeScanner(previewView: previewView)
        print("self.destinationStationName: \(self.destinationStationName)")
        self.destinationLabel.text = self.destinationStationName
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        MTBBarcodeScanner.requestCameraPermission(success: { success in
            if success {
                do {
                    try self.scanner?.startScanning(resultBlock: { codes in
                        if let codes = codes {
                            for code in codes {
                                if self.qrScanAllowed {
                                    self.qrScanAllowed = false
                                    let urlValue = code.stringValue!
                                    print("Found code: \(urlValue)")
                                    // TODO: urlValue 로 연결 [ urlValue = /qr/{station_admin_id}/{index}/{destination_station} ]
                                    let urlDestination = "\(urlValue)/\(self.destinationStationName)"
                                    print("urlDestination:\(urlDestination)")
                                    let encodedUrl = urlDestination.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!
                                    if let url = URL(string: encodedUrl) {
                                        
                                        print("valid url")
                                        Alamofire.request(url).responseJSON(completionHandler: { (response) in
                                            if response.result.isSuccess {
                                                if let value = response.result.value {
                                                    let json = JSON(value)
                                                    let stationName = json["stationName"].stringValue
                                                    guard let direction = Shortest.Direction(rawValue: json["direction"].stringValue) else {
                                                        print("direction converting error")
                                                        return
                                                    }
                                                    print("stationName: \(stationName)")
                                                    print("direction: \(direction)")
                                                
                                                    self.toGo = Shortest(startStation: stationName, direction: direction)
                                                    guard let toGo = self.toGo else {
                                                        print("toGo nil")
                                                        return
                                                    }
                                                    print("startStation: \(toGo.startStation)")
                                                    print("direction: \(toGo.direction)")
                                                    DispatchQueue.main.async { [weak self] in
                                                        self?.departureLabel.text = toGo.startStation
                                                        switch self?.toGo?.direction {
                                                        case .LEFT?:
                                                            self?.leftImage.image = UIImage(named: "RedLeft")
                                                        case .RIGHT?:
                                                            self?.leftImage.image = UIImage(named: "RedRight")
                                                        default:
                                                            break
                                                        }
                                                    }
                                                    self.qrScanAllowed = true
                                                }
                                            } else {
                                                print("Network ERROR")
                                                self.qrScanAllowed = true
                                            }
                                        })
                                    } else {
                                        print("invalid url")
                                        self.qrScanAllowed = true
                                    }
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
    
    override func viewWillDisappear(_ animated: Bool) {
        self.scanner?.stopScanning()
        
        super.viewWillDisappear(animated)
    }
    
    func setDestinationLabel(destinationStationName name: String) {
        self.destinationStationName = name
        
    }
    
}
