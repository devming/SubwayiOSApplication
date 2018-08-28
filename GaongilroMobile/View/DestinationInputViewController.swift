//
//  DestinationInputViewController.swift
//  GaongilroMobile
//
//  Created by Minki on 2018. 1. 15..
//  Copyright © 2018년 devming. All rights reserved.
//

import UIKit

class DestinationInputViewController: UIViewController {
    
    @IBOutlet weak var destinationInput: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func enterButtonTapped(_ sender: UIButton) {
        
        self.performSegue(withIdentifier: "main", sender: sender)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "main" {
            
            if let vc = segue.destination as? MainViewController, let destInput = destinationInput.text {
                vc.setDestinationLabel(destinationStationName: destInput)
            }
        }
    }
}

extension DestinationInputViewController {
//    func checkStationValidation() {
//        // TODO: 입력한 역 이름이 존재하는지 Validation Check 수행 아니라면 return
//        let key = API.valueForAPIKey(keyname: "APIKEY")
//
//        return
//    }
}
