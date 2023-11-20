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
	
	var currentStatus: Bool {
		switch self {
			case .kOn:
				return true
			case .kOff:
				return false
		}
	}
}

enum ToolLightMode: Int, CaseIterable {
    case toggle = 0
    case hold
    
    var name: String {
        switch self {
        case .toggle:
            return "Toggle"
        case .hold:
            return "Hold"
        }
    }
}

enum FlashFacingSide: Int {
    case rear // REAR LED
    case front // SCREEN
    
    var name: String {
        switch self {
        case .front:
            return "Front"
        case .rear:
            return "Rear"
        }
    }
}

class Flashlight: NSObject {

    var loop: Bool = false
    
    var mode: MainMorseViewModel.SOSMode = .sos {
        didSet {
            observableMode = mode.rawValue
        }
    }
    
    @objc dynamic var observableMode: Int = 0

    
    var toolMode: ToolLightMode = .toggle {
        didSet {
            observableToolMode = toolMode.rawValue
        }
    }
    
    @objc dynamic var observableToolMode: Int = 0
    
    var facingSide: FlashFacingSide = .rear {
        didSet {
            observableFacingSide = facingSide.rawValue
        }
    }
    
    @objc dynamic var observableFacingSide: Int = 0
    
    // new klightstate
    @objc dynamic var lightSwitch: Bool = false
    	
    func toggleTorch(on: Bool, side: FlashFacingSide = .rear) {
        self.lightSwitch = on
        
        if side == FlashFacingSide.rear {
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
	}
    
    func updateMode(mode: MainMorseViewModel.SOSMode) {
		self.mode = mode
    }
    
    func flashlightMode() -> MainMorseViewModel.SOSMode {
        return self.mode
    }
    
    func updateToolMode(mode: ToolLightMode) {
        self.toolMode = mode
    }
    
    func updateFacingSide(side: FlashFacingSide) {
        self.facingSide = side
    }
}
