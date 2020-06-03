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
    static let appName = AppMetaData.name
    static let appVersion = AppMetaData.version
    static let deviceType = UIDevice().type
    static let systemVersion = UIDevice.current.systemVersion
	
	let emailBody: String = """
	</br>
	</br>\(appName): \(appVersion!)\n
	</br>iOS: \(systemVersion)
	</br>Device: \(deviceType.rawValue)
	"""
	
	let emailToRecipient: String = "hello@whizbangapps.xyz"
	
	let emailSubject: String = "Morse Code Tool App Feedback"
	
}
