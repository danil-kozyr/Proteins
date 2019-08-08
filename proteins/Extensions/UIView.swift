//
//  UIView.swift
//  proteins
//
//  Created by Daniil KOZYR on 8/6/19.
//  Copyright © 2019 Daniil KOZYR. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    
    func setGradientColor(colorOne: UIColor, colorTwo: UIColor) {
        let gradient = CAGradientLayer()
        
        gradient.frame = bounds
        gradient.colors = [colorOne.cgColor, colorTwo.cgColor]
        gradient.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradient.endPoint = CGPoint(x: 0.0, y: 1.0)
        
        layer.insertSublayer(gradient, at: 0)
    }
    
}
