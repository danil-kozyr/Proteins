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
        touchID.authenticateUser { [unowned self] (result) in
            switch result {
            case .success:
                DispatchQueue.main.sync {
                    let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "ProteinsVC") as! ProteinsVC
                    self.navigationController?.pushViewController(nextVC, animated: true)
                }
            case .error:
                let alert = UIAlertController().createAlert(title: "Authentication Failed", message: "Please authorize using\nFaceID or TouchID", action: "Ok")
                self.present(alert, animated: true)
                return
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.setGradientColor(colorOne: UIColor.Application.darkBlue,
                              colorTwo: UIColor.Application.lightBlue)
        
        loginButton.isHidden = !touchID.canEvaluate()
        
        switch touchID.authorizationType() {
        case .faceID:
            loginButton.setTitle("Login via faceID", for: .normal)
        case .touchID:
            loginButton.setTitle("Login via touchID", for: .normal)
        case .none:
            loginButton.isHidden = true
        }
    }
        
}

