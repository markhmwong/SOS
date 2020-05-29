//
//  IAPProducts.swift
//  Shortlist
//
//  Created by Mark Wong on 14/5/19.
//  Copyright © 2019 Mark Wong. All rights reserved.
//	Base on https://www.raywenderlich.com/5456-in-app-purchase-tutorial-getting-started

import Foundation

public struct IAPProducts {
    
	/// The entire library of products
    public static let entireNonConsumeableProductArray: Set = [
		IAPProducts.productIds.smallId.rawValue,
		IAPProducts.productIds.mediumId.rawValue,
		IAPProducts.productIds.bigId.rawValue,
		IAPProducts.productIds.astronomicalId.rawValue
    ]
    
	/// A collection of tip products
    public static let tipProductArray: Set = [
        IAPProducts.productIds.smallId.rawValue,
        IAPProducts.productIds.mediumId.rawValue,
        IAPProducts.productIds.bigId.rawValue,
		IAPProducts.productIds.astronomicalId.rawValue
    ]

    private static let tipProductIdentifiers: Set<ProductIdentifier> = tipProductArray
    private static let nonConsumableProductIdentifiers: Set<ProductIdentifier> = entireNonConsumeableProductArray

    public static let tipStore = IAPHelper(productIds: IAPProducts.tipProductIdentifiers)
    public static let restoreStore = IAPHelper(productIds: IAPProducts.nonConsumableProductIdentifiers)
}

func resourceNameForProductIdentifier(_ productIdentifier: String) -> String? {
    return productIdentifier.components(separatedBy: ".").last
}

extension IAPProducts {
	
	enum productIds: String, CaseIterable {
		case smallId = "com.whizbang.SOSFlashlightMorseCode.tip.small"
		case mediumId = "com.whizbang.SOSFlashlightMorseCode.tip.medium"
		case bigId = "com.whizbang.SOSFlashlightMorseCode.tip.big"
		case astronomicalId = "com.whizbang.SOSFlashlightMorseCode.tip.astronomical"
	}

}
