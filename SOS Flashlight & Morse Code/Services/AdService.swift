//
//  AdService.swift
//  Warmup HIIT Timer
//
//  Created by Mark Wong on 16/12/2022.
//  Copyright © 2022 Mark Wong. All rights reserved.
//

import Foundation
import AppTrackingTransparency
import AdSupport

class AdService: NSObject {
    
    override init() {
        super.init()
    }
    
    func requestPermission() {
        DispatchQueue.main.async {
            if #available(iOS 14, *) {
                ATTrackingManager.requestTrackingAuthorization { status in
                    switch status {
                        case .authorized:
                            print("enable tracking")
                        case .denied:
                            print("disable tracking")
                        default:
                            print("disable tracking")
                    }
                }
            }
        }

    }
    
}
