//
//  Alert.swift
//  proteins
//
//  Created by Daniil KOZYR on 8/6/19.
//  Copyright © 2019 Daniil KOZYR. All rights reserved.
//

import Foundation
import UIKit

extension UIAlertController {
    
    func createAlert(title: String, message: String, action: String) -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let actionOk = UIAlertAction(title: action, style: .default) { (UIAlertAction) in }

        alert.addAction(actionOk)
        return alert
    }
        
}
