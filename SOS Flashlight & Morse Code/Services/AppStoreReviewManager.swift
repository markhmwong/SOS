//
//  AppStoreReviewManager.swift
//  SOS Flashlight & Morse Code
//
//  Created by Mark Wong on 3/6/20.
//  Copyright © 2020 Mark Wong. All rights reserved.
//

import StoreKit


extension UIApplication {
    var foregroundActiveScene: UIWindowScene? {
        connectedScenes
            .first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene
    }
}

enum AppStoreReviewManager {
    static let minimumReviewWorthyActionCount = 3
    
    private static func requestReview() {
        if #available(iOS 14.0, *) {
            if let scene = UIApplication.shared.foregroundActiveScene {
                SKStoreReviewController.requestReview(in: scene)
            }
        } else {
            SKStoreReviewController.requestReview()
        }
    }
    
    private static func isNewVersion() -> Bool {
        let defaults = UserDefaults.standard
        let bundle = Bundle.main
        var actionCount = defaults.integer(forKey: .reviewWorthyActionCount)
        actionCount += 1
        #if DEBUG
        print("\(actionCount) reviewCount")
        #endif
        defaults.set(actionCount, forKey: .reviewWorthyActionCount)

        guard actionCount >= minimumReviewWorthyActionCount else {
            return false
        }
        
        let bundleVersionKey = kCFBundleVersionKey as String
        let currentVersion = bundle.object(forInfoDictionaryKey: bundleVersionKey) as? String
        let lastVersion = defaults.string(forKey: .lastReviewRequestAppVersion)
        guard lastVersion == nil || lastVersion != currentVersion else {
            return false
        }
        
        defaults.set(0, forKey: .reviewWorthyActionCount)
        defaults.set(currentVersion, forKey: .lastReviewRequestAppVersion)
        return true
    }
    
    static func requestReviewIfAppropriate() {
//        if isNewVersion() {
            requestReview()
//        }
    }
}

extension UserDefaults {
    enum Key: String {
        case reviewWorthyActionCount
        case lastReviewRequestAppVersion
    }
    
    func integer(forKey key: Key) -> Int {
        return integer(forKey: key.rawValue)
    }
    
    func string(forKey key: Key) -> String? {
        return string(forKey: key.rawValue)
    }
    
    func set(_ integer: Int, forKey key: Key) {
        set(integer, forKey: key.rawValue)
    }
    
    func set(_ object: Any?, forKey key: Key) {
        set(object, forKey: key.rawValue)
    }
}
