//
//  Whizbang.swift
//  SOS Flashlight & Morse Code
//
//  Created by Mark Wong on 26/5/20.
//  Copyright © 2020 Mark Wong. All rights reserved.
//

import UIKit

// Whizbang data used for all apps

final class Whizbang {
	
	static let shared: Whizbang = Whizbang()
	
    // Device parameters
	static let appName: String = AppMetaData.name
	static let appVersion: String = AppMetaData.version ?? "-1"
	static let appBuild: String = AppMetaData.build ?? "-1"
	static let deviceType = UIDevice().type
    static let systemVersion = UIDevice.current.systemVersion
	static let appStoreUrl: String = "https://apps.apple.com/app/id1514947015"
	
	static let emailBody: String = """
	</br>
	</br>\(appName): \(appVersion)\n
	</br>iOS: \(systemVersion)
	</br>Device: \(deviceType.rawValue)
	"""
	
	static let emailToRecipient: String = "hello@whizbangapps.xyz"
	
	static let emailSubject: String = "\(appName) App Feedback"
	
}
