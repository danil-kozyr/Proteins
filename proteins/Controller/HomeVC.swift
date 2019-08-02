//
//  ViewController.swift
//  proteins
//
//  Created by Daniil KOZYR on 8/2/19.
//  Copyright © 2019 Daniil KOZYR. All rights reserved.
//

import UIKit


class HomeVC: UIViewController {

    let touchID = BiometricIDAuth()
    
    @IBOutlet weak var loginButton: RoundButton!
    
    @IBAction func loginTapped(_ sender: RoundButton) {
        touchID.authenticateUser { (result) in
            print("success")
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        loginButton.isHidden = !touchID.canEvaluate()
        
//        let image = UIImage(
        
        switch touchID.authorizationType() {
        case .faceID:
            print("faceID")
            loginButton.setImage(UIImage(named: "354"), for: .normal)
        case .touchID:
            print("touchID")
            loginButton.setImage(UIImage(named: "354"), for: .normal)
        case .none:
            print("none")
            loginButton.isHidden = true
        }
        
    }


}

