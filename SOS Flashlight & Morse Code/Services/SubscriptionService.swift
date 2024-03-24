//
//  SubscriptionService.swift
//  SOS Flashlight & Morse Code
//
//  Created by Mark Wong on 26/3/2023.
//  Copyright © 2023 Mark Wong. All rights reserved.
//

import Foundation
import KeychainSwift
import RevenueCat
import UIKit

class SubscriptionService: NSObject {
    
    // trigger this on or off for testing purposes
    private let debugFlagProStatus: Bool = false
    
    static var shared: SubscriptionService = SubscriptionService()
    
    private let keychain = KeychainSwift()
    
    private var isPro: Bool = false
    
    private var purchasedProductIdentifiers: Set<ProductIdentifier> = []

    override init() {
        super.init()
        self.keychain.synchronizable = true
        self.isPro = (keychain.get("isPro") != nil)
    }
    
    func availableProducts(completionHandler: @escaping ([Package]?, PublicError?) ->()) {
        Purchases.shared.getOfferings { offerings, error in
            
            if let offerings = offerings?.current?.availablePackages {
                print("SubscriptionService: \(offerings)")
                for offer in offerings {
                    print(offer.offeringIdentifier)
                }
                completionHandler(offerings, error)
            } else {
                print("SubscriptionService: no product retrieved")
                completionHandler(nil, error)
            }
            
        }
    }
    
    // uses keychain
    func initialiseNoAdsKeychain() {
        if KeychainWrapper.standard.bool(forKey: IAPProducts.adsId) == nil {
            KeychainWrapper.standard.set(false, forKey: IAPProducts.adsId)
        } else {
            print("SubscriptionService: Keychain wrapper ads key has been set. Great!")
        }
    }
    
    func buyAdRemovalIAP() {
        if KeychainWrapper.standard.bool(forKey: IAPProducts.adsId) != nil {
            KeychainWrapper.standard.set(true, forKey: IAPProducts.adsId)
        } else {
            print("SubscriptionService: keychain wrapper ads key not set")
        }
    }
    
    // check whether a product is purchased or not
    func isProductPurchased(completionHandler: @escaping (String) -> ()) {
        Purchases.shared.getCustomerInfo { customerInfo, error in
            if let purchasedProductId = customerInfo?.allPurchasedProductIdentifiers {
                for purchasedProduct in purchasedProductId {
                    print("SubscriptionService: PURCHASED PRODUCTS \(purchasedProduct)")
                    if purchasedProduct == IAPProducts.adsId {
                        completionHandler(purchasedProduct)
                    }
                }
            }
        }
    }
    
    func checkProStatus() {
        Purchases.shared.getCustomerInfo { custInfo, error in
            // custInfo
            if let entitlements = custInfo?.entitlements["pro"] {
                self.updateProState(entitlements.isActive)
            }
        }
    }
    
    private func updateProState(_ state: Bool) {
        keychain.set(state, forKey: "isPro")
    }
    
    func getCustomerProStatusFromKeyChain() -> Bool {
        #if DEBUG
        return debugFlagProStatus
        #else
        return keychain.getBool("isPro") ?? false
        #endif
    }
    
    func lockImage(_ imageName: String? = nil) -> UIImage? {
        if self.getCustomerProStatusFromKeyChain() {
            return UIImage(systemName: "\(imageName ?? "")")
        } else {
            return UIImage(systemName: "lock.fill")
        }
    }
}
