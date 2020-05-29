//
//  ImpactFeedbackService.swift
//  SOS Flashlight & Morse Code
//
//  Created by Mark Wong on 13/5/20.
//  Copyright © 2020 Mark Wong. All rights reserved.
//

import UIKit

class ImpactFeedbackService {
	
	static let shared: ImpactFeedbackService = ImpactFeedbackService()
	
	func impactType(feedBackStyle: UIImpactFeedbackGenerator.FeedbackStyle) {
		let impactFeedbackgenerator = UIImpactFeedbackGenerator(style: feedBackStyle)
		impactFeedbackgenerator.prepare()
		impactFeedbackgenerator.impactOccurred()
	}
	
	func failedFeedback() {
		let generator = UINotificationFeedbackGenerator()
		generator.prepare()
		generator.notificationOccurred(.error)
	}
	
}
