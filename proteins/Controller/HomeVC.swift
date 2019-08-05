//
//  ViewController.swift
//  proteins
//
//  Created by Daniil KOZYR on 8/2/19.
//  Copyright © 2019 Daniil KOZYR. All rights reserved.
//

import UIKit

// TODO: The LoginViewController should ALWAYS be displayed when launching
// the app meaning if you press the Home button and relaunch the app whitout
// quitting it, it should show the LoginViewController !

class HomeVC: UIViewController {

    let touchID = BiometricIDAuth()
    
    @IBOutlet weak var loginButton: RoundButton!
    @IBOutlet weak var label: UILabel!
    
    @IBAction func loginTapped(_ sender: RoundButton) {
        touchID.authenticateUser { (result) in
            switch result {
            case .success:
                DispatchQueue.main.sync {
                    let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "ProteinsVC") as! ProteinsVC
                    self.navigationController?.pushViewController(nextVC, animated: true)
                }
            case .error:
                // TODO: PopUp warning authentication failed
                print("popup warning authentication failed")
            }
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.navigationController?.navigationBar.tintColor = .black
        
//        print(self.navigationController?.navigationBar.backgroundColor)
        
        loginButton.isHidden = !touchID.canEvaluate()
    
        switch touchID.authorizationType() {
        case .faceID:
            loginButton.setImage(UIImage(named: "faceID"), for: .normal)
        case .touchID:
            loginButton.setImage(UIImage(named: "touchID"), for: .normal)
        case .none:
            loginButton.isHidden = true
        }
    }
    



}

