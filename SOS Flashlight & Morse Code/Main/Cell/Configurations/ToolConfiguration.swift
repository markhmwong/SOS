//
//  ToolConfiguration.swift
//  SOS Flashlight & Morse Code
//
//  Created by Mark Wong on 23/6/2022.
//  Copyright © 2022 Mark Wong. All rights reserved.
//

import UIKit

struct ToolConfiguration : UIContentConfiguration {
    var mainItem: SystemModeItem! = nil

    
    func makeContentView() -> UIView & UIContentView {
        let c = ToolView(configuration: self)
        return c
    }
    
    func updated(for state: UIConfigurationState) -> Self {
        guard let _ = state as? UICellConfigurationState else { return self }

        let updatedConfig = self
        return updatedConfig
    }
}

class ToolView: UIView, UIContentView, UITextViewDelegate {
    var configuration: UIContentConfiguration {
        didSet {
            self.configure()
        }
    }
    
    var frontCircleIndicator = CAShapeLayer()

    private var flashlightObserver: NSKeyValueObservation?
    
    var flashlight: Flashlight! = nil
    
    // right side toggle button
    lazy var toggleButton: PaddedButton = {
        let button = PaddedButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("toggle", for: .normal)
        button.setTitleColor(UIColor.defaultWhite, for: .normal) // shoul dbe inverse of button
        button.addTarget(self, action: #selector(handleToggle), for: .touchDown)
        return button
    }()
    
    lazy var bottomBorder: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .black
        return view
    }()
    
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
        guard let config = self.configuration as? ToolConfiguration else { return }
        
        flashlight = config.mainItem.flashlight
        
        flashlightObserver = config.mainItem.flashlight.observe(\.lightSwitch, options:[.new]) { [self] flashlight, change in
            guard let light = change.newValue else { return }
            if flashlight.flashlightMode() == .tools {
                // front facing
                if flashlight.facingSide == .rear {
                    light ? self.updateFrontIndicator(UIColor.Indicator.flashing.cgColor) : self.updateFrontIndicator(UIColor.Indicator.dim.cgColor)
                } else {
                    if light {
                        UIView.animate(withDuration: 0.15, delay: 0.0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: [.curveEaseInOut]) {
                            //self.backgroundColor = UIColor.mainBackground.inverted
                        }
                    } else {
                        UIView.animate(withDuration: 0.15, delay: 0.0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: [.curveEaseInOut]) {
                            //self.backgroundColor = UIColor.mainBackground
                        }
                    }
                }
            }
        }

        // setup toggle button
        toggleButton.setTitle(flashlight.toolMode.name, for: .normal)
        addSubview(toggleButton)
        toggleButton.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        toggleButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -200).isActive = true
    }

    @objc func handleToggle() {
        // when switch between modes, reset the light
        flashlight.toggleTorch(on: false)
        
        // switch between hold mode and toggle
        switch flashlight.toolMode {
        case .hold:
            flashlight.updateToolMode(mode: .toggle)
            toggleButton.setTitle(flashlight.toolMode.name, for: .normal)
        case .toggle:
            flashlight.updateToolMode(mode: .hold)
            toggleButton.setTitle(flashlight.toolMode.name, for: .normal)
        }
    }
        
    deinit {
        // stops watching the variable
        flashlightObserver?.invalidate()
    }
}

