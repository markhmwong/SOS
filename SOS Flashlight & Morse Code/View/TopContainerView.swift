//
//  TopContainerView.swift
//  SOS Flashlight & Morse Code
//
//  Created by Mark Wong on 14/5/20.
//  Copyright © 2020 Mark Wong. All rights reserved.
//

import UIKit

extension TopContainer: UITextViewDelegate {
	
	func textViewDidChange(_ textView: UITextView) {
		let fixedWidth = textView.frame.size.width
		textView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
		let newSize = textView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
		var newFrame = textView.frame
		newFrame.size = CGSize(width: max(newSize.width, fixedWidth), height: newSize.height)
		textView.frame = newFrame
		
		
	}

	func textViewDidBeginEditing(_ textView: UITextView) {
		guard let viewController = viewController else { return }
		if (viewController.mainView.bottomContainer.currState == .kConversion) {
			if (textView.text.isEmpty) {
				textView.text = ""
			}
		}
	}
	
	func textViewDidEndEditing(_ textView: UITextView) {
		print("ended")
	}
	
	func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
		if (text == "\n") {
			guard let viewController = viewController else { return false }
			if (viewController.mainView.bottomContainer.currState == .kMessage) {
				if (textView.text != "") {
					viewController.mainView.bottomContainer.buttonToggleState = true
				}

				retireKeyboardForMessageField()
			} else if (viewController.mainView.bottomContainer.currState == .kConversion) {
				viewController.viewModel?.convertMessageMode()
				textView.resignFirstResponder()
			}
			
			return false
		}
		
		// character limit of 80
		if (textView.text.count + (text.count - range.length) >= 200) {
			ImpactFeedbackService.shared.impactType(feedBackStyle: .heavy)
			return false
		}
		
		if range.location == 0 && text == " " { // prevent space on first character
			return false
		}

		if textView.text?.last == " " && text == " " { // allowed only single space
			return false
		}

		if text == " " { return true } // now allowing space between name

		if text.rangeOfCharacter(from: CharacterSet.alphanumerics.inverted) != nil {
			return false
		}

		return true
	}
}

class TopContainer: UIView {

	// MARK: - Top Toolbar
	lazy var toolBar: UIStackView = {
		let view = UIStackView()
		view.translatesAutoresizingMaskIntoConstraints = false
		view.alignment = .center
		view.distribution = .fillEqually
		return view
	}()
	
	// MARK: - Top Toolbar buttons
	lazy var loopButton: UIButton = {
		let view = UIButton()
		view.contentEdgeInsets = UIEdgeInsets(top: 10.0, left: 0.0, bottom: 10.0, right: 0.0)
		view.setAttributedTitle(NSMutableAttributedString().primaryTextAttributes(string: "Loop"), for: .normal)
		view.addTarget(self, action: #selector(handleLoop), for: .touchDown)
		view.translatesAutoresizingMaskIntoConstraints = false
		return view
	}()
	
	lazy var infoButton: UIButton = {
		let view = UIButton()
		view.contentEdgeInsets = UIEdgeInsets(top: 10.0, left: 0.0, bottom: 10.0, right: 0.0)
		view.setAttributedTitle(NSMutableAttributedString().primaryTextAttributes(string: "Info"), for: .normal)
		view.addTarget(self, action: #selector(handleInfo), for: .touchDown)
		view.translatesAutoresizingMaskIntoConstraints = false
		return view
	}()
	
	override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
		let biggerButtonFrame = loopButton.frame.insetBy(dx: -30, dy: -30)

		if biggerButtonFrame.contains(point) {
		   return loopButton
		}

		return super.hitTest(point, with: event)
	}
	
	lazy var messageContainer: UIView = {
		let view = UIView()
		view.translatesAutoresizingMaskIntoConstraints = false
		return view
	}()
	

	
	lazy var conversionView: UIView = {
		let view = UIView()
		view.backgroundColor = Theme.MessageBox.primary
		view.layer.cornerRadius = 10.0
		view.isHidden = true
		view.translatesAutoresizingMaskIntoConstraints = false
		return view
	}()
	
	lazy var conversionField: UITextView = {
		let textField = UITextView()
		textField.translatesAutoresizingMaskIntoConstraints = false
		textField.keyboardType = .alphabet
		textField.returnKeyType = .default
		textField.enablesReturnKeyAutomatically = false
		textField.attributedText = NSMutableAttributedString().primaryTextAttributes(string: "An interesting message")
		textField.delegate = self
		textField.autocapitalizationType = .none
		textField.autocorrectionType = .no
		textField.textContainer.lineBreakMode = .byWordWrapping
		textField.isHidden = false
		textField.isEditable = true
		textField.backgroundColor = Theme.MessageBox.secondary
		textField.textAlignment = .left
		textField.isScrollEnabled = false
		textField.layer.cornerRadius = 15.0
		return textField
	}()
	
	lazy var resultLabel: UILabel = {
		let label = UILabel()
		label.translatesAutoresizingMaskIntoConstraints = false
		label.attributedText = NSMutableAttributedString().tertiaryTitleAttributes(string: "RESULT")
		return label
	}()
	
	lazy var convertedField: UITextView = {
		let textField = UITextView()
		textField.translatesAutoresizingMaskIntoConstraints = false
		textField.keyboardType = .alphabet
		textField.returnKeyType = .continue
		textField.enablesReturnKeyAutomatically = false
		textField.attributedText = NSMutableAttributedString().primaryTextAttributes(string: "")
		textField.delegate = self
		textField.autocapitalizationType = .none
		textField.autocorrectionType = .no
		textField.isHidden = false
		textField.isEditable = false
		textField.backgroundColor = .clear
		textField.textAlignment = .left
		textField.isScrollEnabled = true
		textField.layer.cornerRadius = 15.0
		return textField
	}()
	
	lazy var messageField: UITextView = {
		let textField = UITextView()
		textField.translatesAutoresizingMaskIntoConstraints = false
		textField.keyboardType = .alphabet
		textField.returnKeyType = .continue
		textField.enablesReturnKeyAutomatically = false
		textField.attributedText = NSMutableAttributedString().primaryTextAttributes(string: "SOS Message")
		textField.delegate = self
		textField.autocapitalizationType = .none
		textField.autocorrectionType = .no
		textField.isHidden = true
		textField.isEditable = false
		textField.backgroundColor = UIColor.white
		textField.textAlignment = .center
		textField.isScrollEnabled = false
		return textField
	}()
	
	lazy var shareButton: UIButton = {
		let button = UIButton()
		button.translatesAutoresizingMaskIntoConstraints = false
		button.backgroundColor = .clear
		button.isHidden = true
		button.addTarget(self, action: #selector(handleShare), for: .touchDown)
		button.setAttributedTitle(NSMutableAttributedString().tertiaryTitleAttributes(string: "SHARE"), for: .normal)
		return button
	}()
	
	lazy var sideIndicatorLabel: UILabel = {
		let label = UILabel()
		label.translatesAutoresizingMaskIntoConstraints = false
		label.backgroundColor = .clear
		label.textAlignment = .center
		label.attributedText = NSMutableAttributedString().tertiaryTitleAttributes(string: "REAR FLASH")
		return label
	}()
	
	lazy var indicator: UIView = {
		let view = UIView()
		view.translatesAutoresizingMaskIntoConstraints = false
		return view
	}()
	
	var frontCircleIndicator = CAShapeLayer()
	
	private var viewController: ViewController?
	
	init(viewController: ViewController?) {
		self.viewController = viewController
		super.init(frame: .zero)
		self.translatesAutoresizingMaskIntoConstraints = false
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	func setupView() {
		addSubview(toolBar)
		toolBar.addArrangedSubview(loopButton)
		toolBar.addArrangedSubview(infoButton)
		addSubview(sideIndicatorLabel)
		let keyboardToolbar = UIToolbar(frame: CGRect(origin: .zero, size: CGSize(width: 100, height: 44.0)))
		let clearButton = UIBarButtonItem(title: "Clear", style: .plain, target: self, action: #selector(handleClear))
		clearButton.tintColor = Theme.Font.DefaultColor
		let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(handleDone))
		doneButton.tintColor = Theme.Font.DefaultColor
		keyboardToolbar.items = [
			clearButton,
			UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil),
			doneButton
		]
		keyboardToolbar.barStyle = .default
		messageField.inputAccessoryView = keyboardToolbar
		messageContainer.addSubview(messageField)
		addSubview(messageContainer)

		addSubview(conversionView)
		conversionView.addSubview(shareButton)
		conversionView.addSubview(resultLabel)
		conversionField.inputAccessoryView = keyboardToolbar
		conversionView.addSubview(conversionField)
		conversionView.addSubview(convertedField)
		let path = UIBezierPath(arcCenter: .zero, radius: 25, startAngle: 0, endAngle: CGFloat.pi * 2, clockwise: true)
		frontCircleIndicator = CAShapeLayer().circularShapeLayer(path: path.cgPath, color: UIColor.clear.cgColor, fillColor: Theme.Indicator.dim.cgColor, strokeEnd: 1, lineWidth: 5)
		layer.addSublayer(frontCircleIndicator)
		
	}
	
	func updateIndicator() {
		DispatchQueue.main.async {
			self.frontCircleIndicator.fillColor = UIColor.orange.cgColor //change size - rear small, front full screen
		}
	}
	
	override func layoutSubviews() {
		super.layoutSubviews()
		frontCircleIndicator.position = center
		sideIndicatorLabel.anchorView(top: toolBar.bottomAnchor, bottom: nil, leading: nil, trailing: nil, centerY: nil, centerX: centerXAnchor, padding: UIEdgeInsets(top: 20.0, left: 15.0, bottom: 0.0, right: -15.0), size: .zero)
		
		messageField.anchorView(top: messageContainer.topAnchor, bottom: nil, leading: messageContainer.leadingAnchor, trailing: messageContainer.trailingAnchor, centerY: nil, centerX: nil, padding: UIEdgeInsets(top: 10.0, left: 15.0, bottom: 0.0, right: -15.0), size: .zero)
		messageContainer.anchorView(top: safeAreaLayoutGuide.centerYAnchor, bottom: nil, leading: leadingAnchor, trailing: trailingAnchor, centerY: nil, centerX: nil, padding: .zero, size: .zero)
		toolBar.anchorView(top: safeAreaLayoutGuide.topAnchor, bottom: nil, leading: leadingAnchor, trailing: trailingAnchor, centerY: nil, centerX: nil, padding: .zero, size: .zero)
		
		conversionView.anchorView(top: nil, bottom: nil, leading: leadingAnchor, trailing: trailingAnchor, centerY: centerYAnchor, centerX: nil, padding: UIEdgeInsets(top: 0.0, left: 15.0, bottom: 0.0, right: -15.0), size: CGSize(width: 0.0, height: bounds.height / 2))
		conversionField.anchorView(top: conversionView.topAnchor, bottom: nil, leading: conversionView.leadingAnchor, trailing: conversionView.trailingAnchor, centerY: nil, centerX: nil, padding: UIEdgeInsets(top: 10.0, left: 10.0, bottom: -10.0, right: -10.0), size: CGSize(width: 0.0, height: 0.0))
		resultLabel.anchorView(top: conversionField.bottomAnchor, bottom: nil, leading: nil, trailing: nil, centerY: nil, centerX: centerXAnchor, padding: UIEdgeInsets(top: 10.0, left: 10.0, bottom: -10.0, right: -10.0), size: .zero)
		convertedField.anchorView(top: resultLabel.bottomAnchor, bottom: shareButton.bottomAnchor, leading: conversionView.leadingAnchor, trailing: conversionView.trailingAnchor, centerY: nil, centerX: nil, padding: UIEdgeInsets(top: 10.0, left: 10.0, bottom: -10.0, right: -10.0), size: .zero)
		
		shareButton.anchorView(top: nil, bottom: conversionView.bottomAnchor, leading: nil, trailing: nil, centerY: nil, centerX: centerXAnchor, padding: UIEdgeInsets(top: 0.0, left: 0.0, bottom: -10.0, right: 0.0), size: .zero)
	}
	
	func updateSideLabel(_ string: String) {
		DispatchQueue.main.async {
			self.sideIndicatorLabel.attributedText = NSMutableAttributedString().tertiaryTitleAttributes(string: string)
		}
	}
	
	func updateFrontIndicator(_ color: CGColor) {
		DispatchQueue.main.async {
			self.frontCircleIndicator.fillColor = color
		}
	}
	
	func retireKeyboardForMessageField() {
		messageField.resignFirstResponder()
		messageField.isHidden = true
		messageField.isEditable = false
		viewController?.viewModel?.message = messageField.text ?? ""
	}
	
	// MARK: - Handle Buttons
	@objc func handleLoop() {
		
	}
	
	@objc func handleInfo() {
		
	}
	
	// button above keyboard
	@objc func handleDone() {
		guard let viewController = viewController else { return }
		if (viewController.mainView.bottomContainer.currState == .kConversion) {
			viewController.viewModel?.convertMessageMode()
			conversionField.resignFirstResponder()
		} else if (viewController.mainView.bottomContainer.currState == .kMessage) {
			messageField.resignFirstResponder()
		}
		
	}
	
	@objc func handleClear() {
		guard let viewController = viewController else { return }

		if (viewController.mainView.bottomContainer.currState == .kConversion) {
			conversionField.text = ""
		} else if (viewController.mainView.bottomContainer.currState == .kMessage) {
			messageField.text = ""
		}
		
	}
	
	@objc func handleShare() {
		viewController?.showSharePanel(text: "test")
	}
}
