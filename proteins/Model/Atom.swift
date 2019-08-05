//
//  Atom.swift
//  proteins
//
//  Created by Daniil KOZYR on 8/5/19.
//  Copyright © 2019 Daniil KOZYR. All rights reserved.
//

import Foundation
import UIKit

//    Carbon                    light grey       [200,200,200]  C8 C8 C8  C
//    Oxygen                    red              [240,0,0]      F0 00 00  O
//    Hydrogen                  white            [255,255,255]  FF FF FF  H
//
//    Nitrogen                  light blue       [143,143,255]  8F 8F FF  N
//    Sulphur                   sulphur yellow   [255,200,50]   FF C8 32  S
//    Chlorine, Boron           green            [0,255,0]      00 FF 00  Cl B
//
//    Phosphorus, Iron, Barium  orange           [255,165,0]    FF A5 00  P Fe Ba
//    Sodium                    blue             [0,0,255]      00 00 FF  Na
//    Magnesium                 forest green     [34,139,34]    22 8B 22  Mg
//    Zn, Cu, Ni, Br            brown            [165,42,42]    A5 2A 2A  Zn Cu Ni Br
//
//    Ca, Mn, Al, Ti, Cr, Ag    dark grey        [128,128,144]  80 80 90  Ca Mn Al Ti Cr Ag
//    F, Si, Au                 goldenrod        [218,165,32]   DA A5 20  F Si Au
//    Iodine                    purple           [160,32.240]   A0 20 F0  I
//
//    Lithium                   firebrick        [178,34,34]    B2 22 22  Li
//    Helium                    pink             [255,192,203]  FF C0 CB  He
//    Unknown                   deep pink        [255,20,147]   FF 14 93

class Atom {
    let name: String
    let id: Int
    let x: Double
    let y: Double
    let z: Double
    let type: String
//    let color: UIColor
    
    init(name: String, id: Int, x: Double, y: Double, z: Double, type: String) {
        self.name = name
        self.id = id
        self.x = x
        self.y = y
        self.z = z
        self.type = type
//        self.color = self.getColor(type: self.type)
    }
    
    func getColor(type: String) -> UIColor {
        switch type.lowercased() {
        case "c":
            return UIColor(red: 200/255, green: 200/255, blue: 200/255, alpha: 1.0)
        case "o":
            return UIColor(red: 240/255, green: 0/255, blue: 0/255, alpha: 1.0)
        case "h":
            return UIColor(red: 200/255, green: 255/255, blue: 255/255, alpha: 1.0)
        case "n":
            return UIColor(red: 143/255, green: 143/255, blue: 255/255, alpha: 1.0)
        case "s":
            return UIColor(red: 255/255, green: 200/255, blue: 50/255, alpha: 1.0)
        case "cl", "b":
            return UIColor(red: 0/255, green: 255/255, blue: 0/255, alpha: 1.0)
        case "p", "fe", "ba":
            return UIColor(red: 255/255, green: 165/255, blue: 0/255, alpha: 1.0)
        case "na":
            return UIColor(red: 0/255, green: 0/255, blue: 255/255, alpha: 1.0)
        case "mg":
            return UIColor(red: 34/255, green: 139/255, blue: 34/255, alpha: 1.0)
        case "zn", "cu", "ni", "br":
            return UIColor(red: 165/255, green: 42/255, blue: 42/255, alpha: 1.0)
        case "ca", "mn", "al", "ti", "cr", "ag":
            return UIColor(red: 128/255, green: 128/255, blue: 144/255, alpha: 1.0)
        case "f", "si", "au":
            return UIColor(red: 218/255, green: 165/255, blue: 32/255, alpha: 1.0)
        case "i":
            return UIColor(red: 160/255, green: 32/255, blue: 240/255, alpha: 1.0)
        case "li":
            return UIColor(red: 178/255, green: 34/255, blue: 34/255, alpha: 1.0)
        case "he":
            return UIColor(red: 255/255, green: 192/255, blue: 203/255, alpha: 1.0)
        default:
            return UIColor(red: 255/255, green: 20/255, blue: 147/255, alpha: 1.0)
        }
    }
    
}
