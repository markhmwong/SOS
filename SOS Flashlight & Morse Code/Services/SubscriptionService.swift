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
    
    static var shared: SubscriptionService = SubscriptionService()
    
    private let keychain = KeychainSwift()
    
    private var isPro: Bool = false
    
    override init() {
        super.init()
        self.keychain.synchronizable = true
        self.isPro = (keychain.get("isPro") != nil)
    }
    
    func availableProducts(completionHandler: @escaping ([Package]) ->()) {
        Purchases.shared.getOfferings { offerings, error in
            
            if let offerings = offerings?.current?.availablePackages {
                print(offerings)
                for offer in offerings {
                    print(offer.offeringIdentifier)
                }
                completionHandler(offerings)
            }
            
        }
    }
    
    // uses keychain
    func initialiseNoAdsKeychain() {
        if KeychainWrapper.standard.bool(forKey: IAPProducts.adsId) == nil {
            KeychainWrapper.standard.set(false, forKey: IAPProducts.adsId)
        }
    }
    
    func buyAdRemovalIAP() {
        if KeychainWrapper.standard.bool(forKey: IAPProducts.adsId) != nil {
            KeychainWrapper.standard.set(true, forKey: IAPProducts.adsId)
        }
    }
    
    // check whether a product is purcahsed or not
    func isProductPurchased(completionHandler: @escaping () ->()) {
        Purchases.shared.getCustomerInfo { customerInfo, error in
            if let purchasedProductId = customerInfo?.allPurchasedProductIdentifiers {
                for purchasedProduct in purchasedProductId {
                    if purchasedProduct == IAPProducts.adsId {
                        completionHandler()
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
    
    func updateProState(_ state: Bool) {
        keychain.set(state, forKey: "isPro")
    }
    
    func proStatus() -> Bool {
        #if DEBUG
        return true
        #else
        return keychain.getBool("isPro") ?? false
        #endif
    }
    
    func lockImage(_ imageName: String? = nil) -> UIImage? {
        if self.proStatus() {
            return UIImage(systemName: "\(imageName ?? "")")
        } else {
            return UIImage(systemName: "lock.fill")
        }
    }
}
