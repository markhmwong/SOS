//
//  MessageConversionConfiguration.swift
//  SOS Flashlight & Morse Code
//
//  Created by Mark Wong on 22/6/2022.
//  Copyright © 2022 Mark Wong. All rights reserved.
//

import UIKit

struct MessageConversionConfiguration : UIContentConfiguration {
    var mainItem: MainMorseViewModel.MainItem! = nil

    
    func makeContentView() -> UIView & UIContentView {
        let c = MessageConversionView(configuration: self)
        return c
    }
    
    func updated(for state: UIConfigurationState) -> Self {
        guard let _ = state as? UICellConfigurationState else { return self }

        let updatedConfig = self
        return updatedConfig
    }
}

class MessageConversionView: UIView, UIContentView, UITextViewDelegate {
    var configuration: UIContentConfiguration {
        didSet {
            self.configure()
        }
    }
    
    var frontCircleIndicator = CAShapeLayer()

    private var flashlightObserver: NSKeyValueObservation?

    let nc = NotificationCenter.default
    
    lazy var messageField: UITextView = {
        let textField = UITextView()
        textField.tintColor = UIColor.defaultText
        textField.font = UIFont.preferredFont(forTextStyle: .title2)
        textField.layer.cornerRadius = 0
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.keyboardType = .alphabet
        textField.returnKeyType = .continue
        textField.enablesReturnKeyAutomatically = false
        textField.text = "Let's send a message"
        textField.delegate = self
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        textField.isEditable = true
        textField.textAlignment = .left
        textField.isScrollEnabled = false
        textField.backgroundColor = UIColor.defaultText.inverted
        return textField
    }()
    
    @objc dynamic var textMessage: String = ""
    

    
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
        
        messageField.topAnchor.constraint(equalTo: topAnchor).isActive = true
        messageField.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        messageField.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
    }
    
    private func configure() {
        guard let config = self.configuration as? MessageConversionConfiguration else { return }
        flashlightObserver = config.mainItem.flashlight.observe(\.lightSwitch, options:[.new]) { [self] flashlight, change in
            guard let light = change.newValue else { return }
            if flashlight.flashlightMode() == .messageConversion {
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
        
        addSubview(messageField)
        messageToolbar()
    }
    
    func messageToolbar() {
        let keyboardToolbar = UIToolbar(frame: CGRect(origin: .zero, size: CGSize(width: 100, height: 44.0)))
        let clearButton = UIBarButtonItem(title: "Clear", style: .plain, target: self, action: #selector(handleClear))
        clearButton.tintColor = UIColor.defaultText
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(handleDone))
        doneButton.tintColor = UIColor.defaultText
        keyboardToolbar.items = [
            clearButton,
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil),
            doneButton
        ]
        keyboardToolbar.barStyle = .default
        messageField.inputAccessoryView = keyboardToolbar

    }
    
    func enableFirstResponder() {
        messageField.becomeFirstResponder()
    }
    
    func disableFirstResponder() {
        messageField.resignFirstResponder()
    }
    
    // button above keyboard
    @objc func handleDone() {
        disableFirstResponder()
        // assign viewmodel.messagetoflash
        nc.post(name: Notification.Name(NotificationCenter.MESSAGE_TO_FLASH), object: nil, userInfo: [NotificationCenter.MESSAGE_TO_FLASH : messageField.text ?? ""])
    }
    
    @objc func handleClear() {
        messageField.text = ""
        // assign viewmodel.messagetoflash
        
    }
    
    
    deinit {
        // stops watching the variable
        flashlightObserver?.invalidate()
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        textMessage = textView.text
    }
}

