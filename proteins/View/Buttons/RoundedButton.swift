//
//  RoundedButton.swift
//  proteins
//
//  Created by Daniil KOZYR on 8/2/19.
//  Copyright © 2019 Daniil KOZYR. All rights reserved.
//

import UIKit

@IBDesignable
class RoundButton: UIButton {
    
    @IBInspectable var cornerRadius: CGFloat = 0{
        didSet{
            self.layer.cornerRadius = cornerRadius
        }
    }
    
    @IBInspectable var borderWidth: CGFloat = 0{
        didSet{
            self.layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable var borderColor: UIColor = UIColor.clear{
        didSet{
            self.layer.borderColor = borderColor.cgColor
        }
    }
}

@IBDesignable
class RoundView: UIView {
    
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            self.layer.cornerRadius = cornerRadius
        }
    }

//    containerView.layer.shadowOpacity = 1
//    containerView.layer.shadowRadius = 2
//    containerView.layer.shadowColor = UIColor(named: "Orange")?.cgColor
    
    
//    @IBInspectable var cornerRadius: CGFloat = 0 {
//        didSet {
//            self.layer.cornerRadius = cornerRadius
//        }
//    }
    
}
