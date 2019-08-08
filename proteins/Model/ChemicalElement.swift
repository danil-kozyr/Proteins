//
//  ChemicalElement.swift
//  proteins
//
//  Created by Daniil KOZYR on 8/8/19.
//  Copyright © 2019 Daniil KOZYR. All rights reserved.
//

import Foundation


class ChemicalElement {
    let symbol: String
    let name: String
    let atomicMass: Float
    let atomicNumber: Int
    let summary: String
    
    init(symbol: String, name: String, atomicMass: Float, atomicNumber: Int, summary: String) {
        self.symbol = symbol
        self.name = name
        self.atomicMass = atomicMass
        self.atomicNumber = atomicNumber
        self.summary = summary
    }
    
}
