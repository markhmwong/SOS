//
//  Flashlight.swift
//  SOS Flightlight & Morse Code
//
//  Created by Mark Wong on 6/5/20.
//  Copyright © 2020 Mark Wong. All rights reserved.
//

import Foundation
import AVFoundation

enum LightState {
	case kOn
	case kOff
	
	var truthValueForState: Bool {
		switch self {
			case .kOn:
				return true
			case .kOff:
				return false
		}
	}
}

class Flashlight {

	private var state: LightState = .kOff
	
	func toggleTorch(on: Bool) {
		guard let device = AVCaptureDevice.default(for: .video) else { return }

		if device.hasTorch {
			do {
				try device.lockForConfiguration()

				if on == true {
					device.torchMode = .on
				} else {
					device.torchMode = .off
				}

				device.unlockForConfiguration()
			} catch {
				print("Torch could not be used")
			}
		} else {
			print("Torch is not available")
		}
	}
	
	func updateState(state: LightState) {
		self.state = state
		
		switch state {
			case .kOn:
				toggleTorch(on: state.truthValueForState)
			case .kOff:
				toggleTorch(on: state.truthValueForState)
		}
	}
}
