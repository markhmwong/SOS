//
//  LocalProductManager.swift
//  SOS Flashlight & Morse Code
//
//  Created by Mark Wong on 24/5/20.
//  Copyright © 2020 Mark Wong. All rights reserved.
//

import Foundation

class LocalProductManager {
    
    static let sharedInstance = LocalProductManager()
    
    private init() {
        
    }
    
    func restorePurchasesToKeyChain(productIdentifier: String) {
        KeychainWrapper.standard.set(true, forKey: productIdentifier)
    }
    
}
