//
//  Atom.swift
//  proteins
//
//  Created by Daniil KOZYR on 8/5/19.
//  Copyright © 2019 Daniil KOZYR. All rights reserved.
//

import Foundation
import UIKit


class Atom {
    let name: String
    let id: Int
    let x: Float
    let y: Float
    let z: Float
    let type: String
    
    init(name: String, id: Int, x: Float, y: Float, z: Float, type: String) {
        self.name = name
        self.id = id
        self.x = x
        self.y = y
        self.z = z
        self.type = type
    }
    
    func getColor(type: String) -> UIColor {
        switch type.lowercased() {
        case "c":                       return UIColor.AtomColor.lightGrey
        case "o":                       return UIColor.AtomColor.red
        case "h":                       return UIColor.AtomColor.white
        case "n":                       return UIColor.AtomColor.lightBlue
        case "s":                       return UIColor.AtomColor.sulphurYellow
        case "cl", "b":                 return UIColor.AtomColor.green
        case "p", "fe", "ba":           return UIColor.AtomColor.orange
        case "na":                      return UIColor.AtomColor.blue
        case "mg":                      return UIColor.AtomColor.forestGreen
        case "zn", "cu", "ni",
             "br":                      return UIColor.AtomColor.brown
        case "ca", "mn", "al",
             "ti", "cr", "ag":          return UIColor.AtomColor.darkGrey
        case "f", "si", "au":           return UIColor.AtomColor.goldenRod
        case "i":                       return UIColor.AtomColor.purple
        case "li":                      return UIColor.AtomColor.fireBrick
        case "he":                      return UIColor.AtomColor.pink
        default:                        return UIColor.AtomColor.deepPink
        }
    }
    
}
