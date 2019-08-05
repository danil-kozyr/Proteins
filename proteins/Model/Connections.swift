//
//  Connections.swift
//  proteins
//
//  Created by Daniil KOZYR on 8/5/19.
//  Copyright © 2019 Daniil KOZYR. All rights reserved.
//

import Foundation

class Connections {
    let mainId: Int
    let ids: [Int]
    
    init(mainId: Int, ids: [Int]) {
        self.mainId = mainId
        self.ids = ids
    }
}
