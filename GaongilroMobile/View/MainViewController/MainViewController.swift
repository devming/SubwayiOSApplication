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
import ARKit

class MainViewController: UIViewController {
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var previewView: ARSCNView!
    @IBOutlet weak var departureLabel: UILabel!
    @IBOutlet weak var destinationLabel: UILabel!
    @IBOutlet weak var leftImage: UIImageView!
    @IBOutlet weak var rightImage: UIImageView!
    @IBOutlet weak var cameraEnablingButton: UIButton!
    @IBOutlet weak var searchTableView: UITableView!
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var cameraLabel: UILabel!
    
    // 화장실일 경우 없앨 녀석들
    @IBOutlet weak var labelStackView: UIStackView!
    @IBOutlet weak var helpBarButton: UIBarButtonItem!
    
    var sceneView: ARSCNView?
    var scanner: MTBBarcodeScanner?
    var destinationStationName = ""
    var onOffFlag = true
    let searchController = UISearchController(searchResultsController: nil)
    var shortestPathInfo: Shortest?
    var toiletShortestPathInfo: ToiletShortest?
    var filteredSubwayList: SubwayLine?
    
    var imageNodeObject: SCNPlane?          // 이미지 오브젝트 내용물
    let defaultImageScale = SCNVector3(3.5, 3.5, 3.5)
    let defaultLeftImagePosition = SCNVector3(-0.6, 0.0, -0.6)
    let defaultRightImagePosition = SCNVector3(0.6, 0.0, -0.6)
    
    var wayFindingMode = WayFindingMode.None
    
    let codeScanningString = " QR Code Scanning... "
    let arViewString = " AR View "
    
    enum Position {
        case Left
        case Right
    }
    
    enum WayFindingMode {
        case Subway
        case Toilet
//        case Bus
//        case Restaurant
        case None
    }
    
    @IBAction func onOffTapped(_ sender: Any) {
        self.onOffFlag = toggleScanning(flag: self.onOffFlag)
        self.cameraLabel.text = self.codeScanningString
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.cameraLabel.text = self.arViewString
        
        switch wayFindingMode {
        case .Subway:
            setupSearchView()
            self.navigationItem.title = "지하철역"
        case .Toilet:
            self.cameraEnablingButton.isEnabled = true
            self.labelStackView.isHidden = true
            self.helpBarButton.isEnabled = false
            self.searchView.isHidden = true
            self.scanner = MTBBarcodeScanner(previewView: self.previewView)
            self.navigationItem.title = "화장실"
        case .None:
            break
        }
        self.previewView.session.run(ARWorldTrackingConfiguration())
        //        self.previewView.debugOptions = [ARSCNDebugOptions.showFeaturePoints, ARSCNDebugOptions.showWorldOrigin]
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        switch wayFindingMode {
        case .Subway:
            self.cameraEnablingButton.isEnabled = !self.destinationStationName.isEmpty
        case .Toilet:
            break
        case .None:
            break
        }
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "info" {
//            segue.destination
//        }
    }
    
    @IBAction func helpTapped(_ sender: UIBarButtonItem) {
        showConfirmationAlert(alertTitle: "사용 방법", alertMessage: "1. 검색창에 목적지역을 입력하세요.\n2. 카메라 아이콘을 누르고 QR코드를 스캔하세요.")
    }
}

extension MainViewController {
    func startIndicator() {
        DispatchQueue.main.async { [weak self] in
            self?.activityIndicator.startAnimating()
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
        }
    }
    
    func stopIndicator() {
        DispatchQueue.main.async { [weak self] in
            self?.cameraEnablingButton.isHidden = false
            self?.scanner?.stopScanning()
            self?.activityIndicator.stopAnimating()
            self?.cameraLabel.text = self?.arViewString
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
        }
    }
    
    func showConfirmationAlert(alertTitle title: String, alertMessage message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(action)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func showActionSheet(alertTitle title: String, alertMessage message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
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
        return !flag
    }
    
    func getJsonData() {
        if let assets = NSDataAsset(name: "subway", bundle: Bundle.main), let lines = try? JSONDecoder().decode(SubwayLine.self, from: assets.data) {
//            insertData(subwayLine: lines)
            SubwayManager.shared.lines = lines
            SubwayManager.shared.filteredLines = lines
        }
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
                    var urlDestination = ""
                    switch self.wayFindingMode {
                    case .Subway:
                        urlDestination  = "\(urlValue)/\(self.destinationStationName)"
                    case .Toilet:
                        self.destinationStationName = "상계"
                        urlDestination  = "\(urlValue)/\(self.destinationStationName)"
//                        urlDestination  = "\(urlValue)"
                    case .None:
                        return
                    }
                    
                    guard let encodedUrl = urlDestination.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed),
                        let url = URL(string: encodedUrl) else {
                            return
                    }
                    
                    self.startIndicator()
                    self.onOffFlag = self.toggleScanning(flag: self.onOffFlag)
                    
                    Alamofire.request(url).responseJSON { [weak self] response in
                        
                        guard let `self` = self else {
                            return
                        }
                        
                        if !response.result.isSuccess {
                            self.showConfirmationAlert(alertTitle: "Error", alertMessage: "Network Error")
                            self.stopIndicator()
                            return
                        }
                        
                        guard let value = response.result.value else {
                            self.showConfirmationAlert(alertTitle: "Error", alertMessage: "Response Data Error")
                            self.stopIndicator()
                            return
                        }
                        
                        switch self.wayFindingMode {
                        case .None:
                            break
                        case .Subway:
                            self.subwayResponse(value: value)
                            break
                        case .Toilet:
                            //                            self.toiletResponse(value: value)
                            self.subwayResponse(value: value)
                            break
                        }
                        self.stopIndicator()
                    }
                }
            } catch {
                self?.cameraLabel.text = self?.arViewString
                self?.showConfirmationAlert(alertTitle: "Error", alertMessage: "Unable to start scanning")
            }
        })
    }
    
    func subwayResponse(value: Any) {
        let json = JSON(value)
        let stationName = json["stationName"].stringValue
        guard let direction = Direction(rawValue: json["direction"].stringValue) else {
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
            self?.departureLabel.text = "\(toGo.startStation)"
            
            switch self?.shortestPathInfo?.direction {
            case .LEFT?:
                self?.leftImage.image = UIImage(named: "ic_red_left")
                self?.rightImage.image = UIImage(named: "ic_gray_right")
                
                if let left = self?.leftImage.image {
                    self?.makeARImage(image: left, position: .Left)
                }
            case .RIGHT?:
                self?.leftImage.image = UIImage(named: "ic_gray_left")
                self?.rightImage.image = UIImage(named: "ic_red_right")
                
                if let right = self?.rightImage.image {
                    self?.makeARImage(image: right, position: .Right)
                }
            default:
                break
            }
            
        }
    }
    
    func toiletResponse(value: Any) {
        let json = JSON(value)
        let toiletNumber = json["toiletNumber"].intValue
        guard let direction = Direction(rawValue: json["direction"].stringValue) else {
            self.showConfirmationAlert(alertTitle: "Error", alertMessage: "Direction Parsing Error")
            self.stopIndicator()
            return
        }
        
        self.toiletShortestPathInfo = ToiletShortest(toiletNumber: toiletNumber, direction: direction)
        
        DispatchQueue.main.async { [weak self] in
            
            switch self?.toiletShortestPathInfo?.direction {
            case .LEFT?:
                self?.leftImage.image = UIImage(named: "ic_red_left")
                self?.rightImage.image = UIImage(named: "ic_gray_right")
                
                if let left = self?.leftImage.image {
                    self?.makeARImage(image: left, position: .Left)
                }
            case .RIGHT?:
                self?.leftImage.image = UIImage(named: "ic_gray_left")
                self?.rightImage.image = UIImage(named: "ic_red_right")
                
                if let right = self?.rightImage.image {
                    self?.makeARImage(image: right, position: .Right)
                }
            default:
                break
            }
            
        }
    }
    
    func makeARImage(image: UIImage, position: Position) {
        
        let material = SCNMaterial()
        material.isDoubleSided = true
        material.diffuse.contents = image
        material.lightingModel = .constant
        let imagePlane = SCNPlane(width: (self.previewView?.bounds.width ?? 6000) / 15000, height: (self.previewView?.bounds.width ?? 6000) / 15000)
//        let imagePlane = SCNPlane(width: 0.5, height: 0.5) // 얘는 정사각형으로 만들어야됨..
        imagePlane.firstMaterial = material
        self.imageNodeObject = imagePlane
        
        let imageNode = SCNNode(geometry: self.imageNodeObject)
        imageNode.scale = self.defaultImageScale
        
        switch position {
        case .Left:
            imageNode.position = (self.previewView?.pointOfView?.position) ?? SCNVector3(0, 0, 0)
            imageNode.position.z -= 0.2
        case .Right:
            imageNode.position = self.previewView?.pointOfView?.position ?? SCNVector3(0, 0, 0)
            imageNode.position.z -= 0.2
        }
        
        /// 추가된 컨텐츠 걸어놓기
        //                                self?.sceneView?.pointOfView?.enumerateChildNodes { (node, _) in
        //                                    node.removeFromParentNode()
        //                                }
        self.previewView?.scene.rootNode.addChildNode(imageNode)
    }
    
    func setupSearchView() {
        // Setup the Search Controller
        self.searchController.searchResultsUpdater = self
        self.searchController.obscuresBackgroundDuringPresentation = false
        self.searchController.searchBar.placeholder = "검색"
        navigationItem.searchController = self.searchController
        definesPresentationContext = true
        
        self.scanner = MTBBarcodeScanner(previewView: self.previewView)
        
        getJsonData()
        
        self.searchView.translatesAutoresizingMaskIntoConstraints = false
        let leading = NSLayoutConstraint(item: self.searchView, attribute: .leading, relatedBy: .equal, toItem: self.view.safeAreaLayoutGuide.owningView, attribute: .leading, multiplier: 1.0, constant: 0)
        let trailing = NSLayoutConstraint(item: self.searchView, attribute: .trailing, relatedBy: .equal, toItem: self.view.safeAreaLayoutGuide.owningView, attribute: .trailing, multiplier: 1.0, constant: 0)
        let top = NSLayoutConstraint(item: self.searchView, attribute: .top, relatedBy: .equal, toItem: self.view.safeAreaLayoutGuide.owningView, attribute: .top, multiplier: 1.0, constant: 0)
        let bottom = NSLayoutConstraint(item: self.searchView, attribute: .bottom, relatedBy: .equal, toItem: self.view.safeAreaLayoutGuide.owningView, attribute: .bottom, multiplier: 1.0, constant: 0)
        self.view.addSubview(self.searchView)
        self.view.addConstraints([leading, trailing, top, bottom])
        self.searchView.isHidden = true
    }
}

/* TODO:
 1. 화장실일 경우
 QR코드 등록을 새로 설정해서
 화장실왼쪽오른쪽 설정하도록!
 
 
 */
