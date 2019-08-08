//
//  FileReader.swift
//  proteins
//
//  Created by Daniil KOZYR on 8/3/19.
//  Copyright © 2019 Daniil KOZYR. All rights reserved.
//

import Foundation

class FileReader {
    
    private let fileName = "ligands"
    private let fileType = "txt"
    
    func reader() -> [String] {

        if let filePath = Bundle.main.path(forResource: fileName, ofType: fileType) {
            do {
                let contents = try String(contentsOfFile: filePath)
                var strArray = contents.components(separatedBy: "\n")
                strArray.removeLast()
                return strArray
            } catch {
                return ["Error"]
            }
        } else {
            return ["Error"]
        }
    }
    
}
