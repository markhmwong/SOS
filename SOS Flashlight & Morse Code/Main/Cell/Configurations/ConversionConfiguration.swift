//
//  ConversionConfiguration.swift
//  SOS Flashlight & Morse Code
//
//  Created by Mark Wong on 25/6/2022.
//  Copyright © 2022 Mark Wong. All rights reserved.
//

import UIKit

struct ConversionConfiguration : UIContentConfiguration {
    var mainItem: MainMorseViewModel.MainItem! = nil

    
    func makeContentView() -> UIView & UIContentView {
        let c = ConversionView(configuration: self)
        return c
    }
    
    func updated(for state: UIConfigurationState) -> Self {
        guard let _ = state as? UICellConfigurationState else { return self }

        let updatedConfig = self
        return updatedConfig
    }
}

class ConversionView: UIView, UIContentView, UITextViewDelegate {
    var configuration: UIContentConfiguration {
        didSet {
            self.configure()
        }
    }
    

    private var flashlightObserver: NSKeyValueObservation?
    
    var flashlight: Flashlight! = nil
    
    //top text view
    lazy var topTextView: UITextView = {
        let textField = UITextView()
        textField.tintColor = UIColor.defaultText
        textField.layer.cornerRadius = 0
        textField.font = UIFont.preferredFont(forTextStyle: .title2)
        textField.text = "top"
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.keyboardType = .alphabet
        textField.returnKeyType = .continue
        textField.enablesReturnKeyAutomatically = false
        textField.delegate = self
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        textField.isEditable = true
        textField.textContainerInset = UIEdgeInsets(top: 20, left: 0, bottom: 20, right: 0)
        textField.textAlignment = .left
        textField.isScrollEnabled = false

        return textField
    }()
    
    
    //bottom text view
    lazy var bottomTextView: UITextView = {
        let textField = UITextView()
        textField.tintColor = UIColor.defaultText
        textField.layer.cornerRadius = 0
        textField.font = UIFont.preferredFont(forTextStyle: .title2)
        textField.text = "bottom"
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.keyboardType = .alphabet
        textField.returnKeyType = .continue
        textField.enablesReturnKeyAutomatically = false
        textField.delegate = self
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        textField.isEditable = false
        textField.textContainerInset = UIEdgeInsets(top: 20, left: 0, bottom: 20, right: 0)
        textField.textAlignment = .left
        textField.isScrollEnabled = true
        return textField
    }()
    
    let nc = NotificationCenter.default

    lazy var bottomBorder: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.defaultText.withAlphaComponent(0.4)
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
    
    private func configure() {
        guard let config = self.configuration as? ConversionConfiguration else { return }
        addSubview(topTextView)
        addSubview(bottomTextView)
        addSubview(bottomBorder)
        
        bottomBorder.bottomAnchor.constraint(equalTo: topTextView.bottomAnchor).isActive = true
        bottomBorder.leadingAnchor.constraint(equalTo: topTextView.leadingAnchor).isActive = true
        bottomBorder.trailingAnchor.constraint(equalTo: topTextView.trailingAnchor).isActive = true
        bottomBorder.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        topTextView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor).isActive = true
        topTextView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        topTextView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        
        bottomTextView.topAnchor.constraint(equalTo: topTextView.bottomAnchor).isActive = true
        bottomTextView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        bottomTextView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        bottomTextView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true

        
        flashlight = config.mainItem.flashlight
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
        topTextView.inputAccessoryView = keyboardToolbar

    }
    
    @objc func handleClear() {
        topTextView.text = ""
        bottomTextView.text = ""
    }
    
    @objc func handleDone() {
        topTextView.resignFirstResponder()
        nc.post(name: Notification.Name(NotificationCenter.MESSAGE_TO_TEXT), object: nil)
        let parser = MorseParser(message: topTextView.text)
        bottomTextView.text = String(parser.removeErroneousCharacters())
    }
        
    deinit {
        // stops watching the variable
        flashlightObserver?.invalidate()
    }
}

