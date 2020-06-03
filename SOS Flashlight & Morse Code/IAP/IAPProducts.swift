//
//  IAPProducts.swift
//  Shortlist
//
//  Created by Mark Wong on 14/5/19.
//  Copyright © 2019 Mark Wong. All rights reserved.
//	Based on https://www.raywenderlich.com/5456-in-app-purchase-tutorial-getting-started

import Foundation

public struct IAPProducts {
    
	/// The entire library of products
    public static let entireNonConsumeableProductArray: Set = [
		IAPProducts.smallId,
		IAPProducts.mediumId,
		IAPProducts.bigId,
		IAPProducts.astronomicalId
    ]
    
	/// A collection of tip products
    public static let tipProductArray: Set = [
        IAPProducts.smallId,
        IAPProducts.mediumId,
        IAPProducts.bigId,
		IAPProducts.astronomicalId
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
	
	static let smallId = "com.whizbang.SOSFlashlightMorseCode.tip.small"
	static let mediumId = "com.whizbang.SOSFlashlightMorseCode.tip.medium"
	static let bigId = "com.whizbang.SOSFlashlightMorseCode.tip.big"
	static let astronomicalId = "com.whizbang.SOSFlashlightMorseCode.tip.astronomical"
}
