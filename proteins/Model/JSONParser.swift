//
//  JSONParser
//  proteins
//
//  Created by Daniil KOZYR on 8/8/19.
//  Copyright © 2019 Daniil KOZYR. All rights reserved.
//

import Foundation
import SwiftyJSON

class JSONParser {
    private let fileName = "PeriodicTableJSON"
    private let fileType = "json"
    
    func parse(elementType: String) -> ChemicalElement? {
        if let path = Bundle.main.path(forResource: fileName, ofType: fileType) {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let jsonResult = try JSON(data: data)
                let elements = jsonResult["elements"].array

                for element in elements! {
                    if element["symbol"].string?.lowercased() == elementType.lowercased() {
                        let symbol = element["symbol"].string
                        let name = element["name"].string
                        let atomicMass = element["atomic_mass"].float
                        let atomicNumber = element["number"].int
                        let summary = element["summary"].string
                        
                        let chemicalElement = ChemicalElement(symbol: symbol!,
                                                              name: name!,
                                                              atomicMass: atomicMass!,
                                                              atomicNumber: atomicNumber!,
                                                              summary: summary!)
                        return chemicalElement
                    }
                }
                
            } catch {
                return nil
            }
        }
        return nil
    }

}
