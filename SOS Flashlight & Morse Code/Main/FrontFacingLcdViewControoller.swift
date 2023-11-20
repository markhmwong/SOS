//
//  FrontFacingLightViewControoller.swift
//  SOS Flashlight & Morse Code
//
//  Created by Mark on 12/11/2023.
//  Copyright © 2023 Mark Wong. All rights reserved.
//

import UIKit

// Flashes the entire view white if front mode selected
class FrontFacingLcdViewController: UIViewController {
	
	override func viewDidLoad() {
		super.viewDidLoad()
		self.view.backgroundColor = .clear
	}
	
	func updateBackgroundWith(color: UIColor) {
		self.view.backgroundColor = color
	}
	
	func on(color: UIColor = UIColor.mainBackground.inverted) {
		self.view.backgroundColor = color
	}
	
	func off(color: UIColor = UIColor.mainBackground) {
		self.view.backgroundColor = color
	}
}
