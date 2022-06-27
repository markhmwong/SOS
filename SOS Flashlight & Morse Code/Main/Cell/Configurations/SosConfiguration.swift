//
//  SosConfiguration.swift
//  SOS Flashlight & Morse Code
//
//  Created by Mark Wong on 20/6/2022.
//  Copyright © 2022 Mark Wong. All rights reserved.
//

import UIKit

struct SosItemConfiguration : UIContentConfiguration {
    var mainItem: MainMorseViewModel.MainItem! = nil

    
    func makeContentView() -> UIView & UIContentView {
        let c = SosView(configuration: self)
        return c
    }
    
    func updated(for state: UIConfigurationState) -> Self {
        guard let _ = state as? UICellConfigurationState else { return self }

        let updatedConfig = self
        return updatedConfig
    }
}

class SosView: UIView, UIContentView {
    var configuration: UIContentConfiguration {
        didSet {
            self.configure()
        }
    }
    
    var frontCircleIndicator = CAShapeLayer()

    private var flashlightObserver: NSKeyValueObservation?

    init(configuration: UIContentConfiguration) {
        self.configuration = configuration
        super.init(frame: .zero)
        self.configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func createCircleIndicator() {
        let path = UIBezierPath(arcCenter: .zero, radius: 25, startAngle: 0, endAngle: CGFloat.pi * 2, clockwise: true)
        frontCircleIndicator = CAShapeLayer().circularShapeLayer(path: path.cgPath, color: UIColor.clear.cgColor, fillColor: UIColor.Indicator.dim.cgColor, strokeEnd: 1, lineWidth: 5)
        layer.addSublayer(frontCircleIndicator)
    }
    
    func updateIndicator() {
        DispatchQueue.main.async {
            self.frontCircleIndicator.fillColor = UIColor.orange.cgColor //change size - rear small, front full screen
        }
    }
    
    func updateFrontIndicator(_ color: CGColor) {
        DispatchQueue.main.async {
            self.frontCircleIndicator.fillColor = color
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.createCircleIndicator()
        frontCircleIndicator.position = CGPoint(x: center.x, y: center.y - (UIScreen.main.bounds.height / 5))
    }
    
    private func configure() {
        guard let config = self.configuration as? SosItemConfiguration else { return }
        flashlightObserver = config.mainItem.flashlight.observe(\.lightSwitch, options:[.new]) { [self] flashlight, change in
            guard let light = change.newValue else { return }
            if flashlight.flashlightMode() == .sos {
                
                // front facing
                if flashlight.facingSide == .rear {
                    light ? self.updateFrontIndicator(UIColor.Indicator.flashing.cgColor) : self.updateFrontIndicator(UIColor.Indicator.dim.cgColor)
                } else {
                    if light {
                        UIView.animate(withDuration: 0.15, delay: 0.0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: [.curveEaseInOut]) {
                            self.backgroundColor = UIColor.mainBackground.inverted
                        }
                    } else {
                        UIView.animate(withDuration: 0.15, delay: 0.0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: [.curveEaseInOut]) {
                            self.backgroundColor = UIColor.mainBackground
                        }
                    }
                }
                
            }
        }
    }
    
    deinit {
        // stops watching the variable
        flashlightObserver?.invalidate()
    }
}
