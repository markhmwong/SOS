//
//  TelemtryKeys.swift
//  SOS Flashlight & Morse Code
//
//  Created by Mark Wong on 15/8/2022.
//  Copyright © 2022 Mark Wong. All rights reserved.
//

import TelemetryClient

extension TelemetryManager {
    enum Signal: String {
        case tipDidShow
        case tipDidPurchase
        
        case appDidBecomeActive
        case appDidBecomeInactive
        case settingsDidShow
        case appDidEnterForeground
        case appDidEnterBackground
        case appDidDisconnect
        case appWillResignActive
        
        case sosToggleDidFire
        case sosMessageConversionDidFire
        case sosToolsDidFire
        case sosMorseConversionDidFire
        
        case appId = "F4D1D777-628E-4F25-98D0-6FC8604F3858"
    }
}
