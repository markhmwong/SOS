//
//  CAShapelayerExtension.swift
//  Warmup HIIT Timer
//
//  Created by Mark Wong on 14/4/20.
//  Copyright © 2020 Mark Wong. All rights reserved.
//

import UIKit

extension CAShapeLayer {
	func circularShapeLayer(path: CGPath, color: CGColor, fillColor: CGColor, strokeEnd: CGFloat = 1, lineWidth: CGFloat) -> CAShapeLayer {
		self.path = path
        self.strokeColor = color
        self.fillColor = fillColor
        self.lineCap = .round
        self.lineWidth = lineWidth
		self.strokeStart = 0.0
		self.strokeEnd = strokeEnd
		self.transform = CATransform3DMakeRotation(-CGFloat.pi / 2, 0, 0, 1)
        return self
    }
}
