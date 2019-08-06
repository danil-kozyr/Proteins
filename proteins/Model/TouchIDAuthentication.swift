//
//  TouchIDAuthentication.swift
//  proteins
//
//  Created by Daniil KOZYR on 8/2/19.
//  Copyright © 2019 Daniil KOZYR. All rights reserved.
//

import Foundation

import LocalAuthentication

class BiometricIDAuth {
 
    let context = LAContext()
    var reason = String()
    
    enum BiometryType {
        case none
        case touchID
        case faceID
    }
    
    enum Response {
        case success
        case error
    }
    
    func canEvaluate() -> Bool {
        return context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil)
    }
    
    func authorizationType() -> BiometryType {
        switch context.biometryType {
        case .none:
            return .none
        case .touchID:
            reason = "Logging in with Touch ID"
            return .touchID
        case .faceID:
            reason = "Logging in with Face ID"
            return .faceID
        default:
            return .none
        }
    }
    
    func authenticateUser(completion: @escaping (Response) -> Void) {
        guard canEvaluate() else {
            return
        }
        context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { (success, error) in
            if success {
                completion(.success)
            } else {
                completion(.error)
            }
        }
    }
    
    
    
}

