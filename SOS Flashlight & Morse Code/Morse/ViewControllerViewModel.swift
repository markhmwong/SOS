//
//  ViewControllerViewModel.swift
//  SOS Flashlight & Morse Code
//
//  Created by Mark Wong on 14/5/20.
//  Copyright © 2020 Mark Wong. All rights reserved.
//

import Foundation

class ViewControllerViewModel {
	var flashFacingSideState: FlashFacingSide = .rear

	var lightState: LightState = .kOff
	
	var viewController: ViewController?
	
	var kFrontLightState: Bool = false
	
	var kLightState: Bool =  false {
		didSet {
			kLightState ? viewController?.mainView.topContainer.updateFrontIndicator(Theme.Indicator.flashing.cgColor)
				: viewController?.mainView.topContainer.updateFrontIndicator(Theme.Indicator.dim.cgColor)
		}
	}
	
	var message: String = ""
	
	init(viewController: ViewController) {
		self.viewController = viewController
	}
	
	func convertMessageMode() {
		guard let viewController = viewController else { return }
		let messageToConvert = viewController.mainView.topContainer.conversionField.text
		let parser = MorseParser(message: messageToConvert ?? "")
		viewController.mainView.topContainer.shareButton.isHidden = false
		viewController.mainView.topContainer.convertedField.attributedText = NSMutableAttributedString().cellTitleAttributes(string: String(parser.removeErroneousCharacters()))
	}
}
