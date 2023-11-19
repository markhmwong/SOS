//
//  Once.swift
//  SOS Flashlight & Morse Code
//
//  Created by Mark on 8/11/2023.
//  Copyright © 2023 Mark Wong. All rights reserved.
//

import Foundation

// Loads only one time per update
final class Once {
	private var version: String = KeychainWrapper.standard.string(forKey: "com.whizbang.sos.appversion") ?? "1.0"
	
	func run(action: () -> Void) {
		// handle new version
		if (version != Whizbang.appVersion) {
			action()
			KeychainWrapper.standard.set(Whizbang.appVersion, forKey: "com.whizbang.sos.appversion")
		}
	}
}
