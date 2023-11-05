//
//  NotificationCenter.swift
//  SOS Flashlight & Morse Code
//
//  Created by Mark Wong on 26/6/2022.
//  Copyright © 2022 Mark Wong. All rights reserved.
//

import Foundation

extension NotificationCenter {
    
	struct NCKeys {
		static var MESSAGE_TO_FLASH: String = "MessageToFlash"
		
		static var MESSAGE_TO_TEXT: String = "MessageToText"
		
		static var TRACKED_CHARACTERS: String = "TrackedCharactersLiveText"
		
		static var END_STATE: String = "EndState"
	}
	

}
