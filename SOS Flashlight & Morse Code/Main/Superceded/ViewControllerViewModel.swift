////
////  ViewControllerViewModel.swift
////  SOS Flashlight & Morse Code
////
////  Created by Mark Wong on 14/5/20.
////  Copyright © 2020 Mark Wong. All rights reserved.
////
//
//import Foundation
//
//class ViewControllerViewModel {
//
//    var viewController: ViewController?
//
//	var flashFacingSideState: FlashFacingSide = .rear
//
//	var lightState: LightState = .kOff
//
//	var kFrontLightState: Bool = false
//
//	var kLightState: Bool =  false {
//		didSet {
////			kLightState ? viewController?.mainView.topContainer.updateFrontIndicator(Theme.Indicator.flashing.cgColor)
////				: viewController?.mainView.topContainer.updateFrontIndicator(Theme.Indicator.dim.cgColor)
//		}
//	}
//
//	var loopState: Bool = false {
//		didSet {
//			viewController?.mainView.topContainer.loopButton.alpha = loopState ? 1.0 : 0.5
//		}
//	}
//
//	var message: String = ""
//
//	var conversionMessage: String = ""
//
//	init(viewController: ViewController) {
//		self.viewController = viewController
//	}
//
//	func convertMessageMode(text: String) {
//
//		guard let viewController = viewController else { return }
//		let parser = MorseParser(message: text)
//		viewController.mainView.topContainer.shareButton.isHidden = false
//		viewController.mainView.topContainer.convertedField.attributedText = NSMutableAttributedString().cellTitleAttributes(string: String(parser.removeErroneousCharacters()))
//	}
//}
