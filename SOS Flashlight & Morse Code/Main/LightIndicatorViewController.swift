//
//  LightIndicatorViewController.swift
//  SOS Flashlight & Morse Code
//
//  Created by Mark on 13/11/2023.
//  Copyright © 2023 Mark Wong. All rights reserved.
//

import UIKit

class LightIndicatorViewController: UIViewController {
	
	var frontCircleIndicator = CAShapeLayer()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		view.alpha = 0
		view.backgroundColor = .clear
		createCircleIndicator()
	}
	
	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		frontCircleIndicator.position = CGPoint(x: view.center.x, y: view.center.y + 15)
	}
	
	private func createCircleIndicator() {
		let path = UIBezierPath(arcCenter: .zero, radius: UIScreen.main.bounds.height * 0.05, startAngle: 0, endAngle: CGFloat.pi * 2, clockwise: true)
		frontCircleIndicator = CAShapeLayer().circularShapeLayer(path: path.cgPath, color: UIColor.clear.cgColor, fillColor: UIColor.Indicator.dim.cgColor, strokeEnd: 1, lineWidth: 5)
		view.layer.addSublayer(frontCircleIndicator)
		frontCircleIndicator.fillColor = UIColor.orange.cgColor
		indicatorState(on: false)
	}
	
	func indicatorState(on: Bool) {
		if on {
			DispatchQueue.main.async {
				self.frontCircleIndicator.opacity = 1.0 //change size - rear small, front full screen
			}
		} else {
			DispatchQueue.main.async {
				self.frontCircleIndicator.opacity = 0.1
			}
		}

	}
}
