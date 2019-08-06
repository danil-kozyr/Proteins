//
//  String.swift
//  proteins
//
//  Created by Daniil KOZYR on 8/6/19.
//  Copyright © 2019 Daniil KOZYR. All rights reserved.
//

import Foundation


extension String {

    var condensedWhitespace: String {
        let components = self.components(separatedBy: .whitespaces)
        return components.filter { !$0.isEmpty }.joined(separator: " ")
    }

    func containsIgnoringCase(find: String) -> Bool{
        return self.range(of: find, options: .caseInsensitive) != nil
    }

}
