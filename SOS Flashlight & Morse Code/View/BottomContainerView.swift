//
//  BottomContainerView.swift
//  SOS Flashlight & Morse Code
//
//  Created by Mark Wong on 14/5/20.
//  Copyright © 2020 Mark Wong. All rights reserved.
//

import UIKit

//MARK: - Bottom Container
class BottomContainer: UIView, UIGestureRecognizerDelegate, UIScrollViewDelegate {
	
	enum TapDirection {
		case left
		case right
	}
	
	// MARK: - Class variables and states
	private var contentSize: CGFloat = .zero
	
	private var currIndex: Int
	
	var currState: MorseCodeMode
	
	private weak var viewModel: ViewControllerViewModel?
	
	private weak var viewController: ViewController?
	
	var buttonToggleState: Bool = true {
		didSet {
			toggleButton.isEnabled = buttonToggleState
			toggleButton.alpha = toggleButton.isEnabled ? 1.0 : 0.1
		}
	}
	
	// MARK: - Views
	lazy var leftTapArea: UIView = {
		let view = UIView()
		view.translatesAutoresizingMaskIntoConstraints = false
		view.backgroundColor = .clear
		return view
	}()
	
	lazy var rightTapArea: UIView = {
		let view = UIView()
		view.backgroundColor = .clear
		view.translatesAutoresizingMaskIntoConstraints = false
		return view
	}()
	
	lazy var scrollView: UIScrollView = {
		let view = UIScrollView()
		view.isScrollEnabled = false
		view.delegate = self
		view.showsHorizontalScrollIndicator = false
		view.translatesAutoresizingMaskIntoConstraints = false
		return view
	}()
	
	// MARK: - Buttons
	lazy var switchSideButton: UIButton = {
		let button = UIButton()
		button.setImage(UIImage(named: "switchSide.png"), for: .normal)
		button.translatesAutoresizingMaskIntoConstraints = false
		button.addTarget(self, action: #selector(handleSideSwitch), for: .touchDown)
		return button
	}()
	
	lazy var toggleButton: UIButton = {
		let button = UIButton()
		button.addTarget(self, action: #selector(handleToggle), for: .touchDown)
		button.translatesAutoresizingMaskIntoConstraints = false
		return button
	}()
	
	lazy var messageButton: UIButton = {
		let button = UIButton()
		button.addTarget(self, action: #selector(handleMessage), for: .touchDown)
		button.setImage(UIImage(named: "compose.png"), for: .normal)
		button.translatesAutoresizingMaskIntoConstraints = false
		button.alpha = 0.3
		button.isEnabled = false
		return button
	}()
	
	// MARK: - Gestures
	private var longPressGesture: UILongPressGestureRecognizer = {
		let gesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress))
		return gesture
	}()

	private lazy var leftTapGesture: UITapGestureRecognizer = {
		let gesture = UITapGestureRecognizer(target: self, action: #selector(handleLeftArea))
		return gesture
	}()
	
	private lazy var rightTapGesture: UITapGestureRecognizer = {
		let gesture = UITapGestureRecognizer(target: self, action: #selector(handleRightArea))
		return gesture
	}()
	
	private lazy var horizontalSwipeGesture: UIPanGestureRecognizer = {
		let gesture = UIPanGestureRecognizer(target: self, action: #selector(handleHorizontalGestureRecognizer))
		gesture.maximumNumberOfTouches = 1
		gesture.minimumNumberOfTouches = 1
		gesture.delegate = self
		return gesture
	}()
	
	// MARK: - Labels
	private lazy var sosLabel: UILabel = {
		let label = UILabel()
		label.translatesAutoresizingMaskIntoConstraints = false
		label.backgroundColor = .clear
		label.textAlignment = .center
		label.attributedText = NSMutableAttributedString().secondaryTitleAttributes(string: "SOS")
		return label
	}()
	
	private lazy var messageLabel: UILabel = {
		let label = UILabel()
		label.translatesAutoresizingMaskIntoConstraints = false
		label.backgroundColor = .clear
		label.textAlignment = .center
		label.attributedText = NSMutableAttributedString().secondaryTitleAttributes(string: "MESSAGE")
		return label
	}()
	
	private lazy var conversionLabel: UILabel = {
		let label = UILabel()
		label.translatesAutoresizingMaskIntoConstraints = false
		label.backgroundColor = .clear
		label.textAlignment = .center
		label.attributedText = NSMutableAttributedString().secondaryTitleAttributes(string: "CONVERSION")
		return label
	}()
	
	lazy var switchLabel: UILabel = {
		let label = UILabel()
		label.backgroundColor = .clear
		label.translatesAutoresizingMaskIntoConstraints = false
		label.textAlignment = .center
		label.attributedText = NSMutableAttributedString().secondaryTitleAttributes(string: "SWITCH")
		return label
	}()

	lazy var holdLabel: UILabel = {
		let label = UILabel()
		label.backgroundColor = .clear
		label.translatesAutoresizingMaskIntoConstraints = false
		label.textAlignment = .center
		label.attributedText = NSMutableAttributedString().secondaryTitleAttributes(string: "HOLD")
		return label
	}()
	
	// MARK: - Shapes
	private var buttonShapeLayer = CAShapeLayer()
	
	private var buttonShapeOutline = CAShapeLayer()
	
	init(viewModel: ViewControllerViewModel?, viewController: ViewController?) {
		self.viewController = viewController
		self.viewModel = viewModel
		self.currIndex = 0
		self.currState = MorseCodeMode.init(rawValue: currIndex) ?? MorseCodeMode.kMessage
		super.init(frame: .zero)
		self.translatesAutoresizingMaskIntoConstraints = false
	}
	
	required init?(coder: NSCoder) {
		self.currIndex = 0
		self.currState = MorseCodeMode.init(rawValue: currIndex) ?? MorseCodeMode.kMessage
		super.init(coder: coder)
	}
	
	// MARK: - Setupview
	func setupView() {
		addSubview(scrollView)
		
		//taps area
		leftTapArea.addGestureRecognizer(leftTapGesture)
		rightTapArea.addGestureRecognizer(rightTapGesture)
		
		addSubview(leftTapArea)
		addSubview(rightTapArea)
		
		addGestureRecognizer(horizontalSwipeGesture)
		scrollView.addSubview(sosLabel)

		scrollView.addSubview(messageLabel)
		scrollView.addSubview(switchLabel)
		scrollView.addSubview(holdLabel)
		scrollView.addSubview(conversionLabel)
		
		addSubview(messageButton)
		addSubview(switchSideButton)
		addSubview(toggleButton)
		
		let path = UIBezierPath(arcCenter: .zero, radius: 25, startAngle: 0, endAngle: CGFloat.pi * 2, clockwise: true)
		buttonShapeLayer = CAShapeLayer().circularShapeLayer(path: path.cgPath, color: UIColor.white.cgColor, fillColor: UIColor.white.cgColor, strokeEnd: 1, lineWidth: 5)
		toggleButton.layer.addSublayer(buttonShapeLayer)
		
		let outlinePath = UIBezierPath(arcCenter: .zero, radius: 35, startAngle: 0, endAngle: CGFloat.pi * 2, clockwise: true)
		buttonShapeOutline = CAShapeLayer().circularShapeLayer(path: outlinePath.cgPath, color: UIColor.white.cgColor, fillColor: UIColor.clear.cgColor, strokeEnd: 1, lineWidth: 3)
		toggleButton.layer.addSublayer(buttonShapeOutline)

	}
	
	// MARK: -  Constraints
	override func layoutSubviews() {
		super.layoutSubviews()
		contentSize = bounds.width / 3.0
		
		buttonShapeLayer.position = CGPoint(x: toggleButton.bounds.midX, y: toggleButton.bounds.midY)
		buttonShapeOutline.position = CGPoint(x: toggleButton.bounds.midX, y: toggleButton.bounds.midY)
		
		let iconSize = CGSize(width: bounds.width * 0.08, height: bounds.width * 0.08)
		
		switchSideButton.anchorView(top: nil, bottom: nil, leading: nil, trailing: trailingAnchor, centerY: centerYAnchor, centerX: nil, padding: UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: -20.0), size: iconSize)
		toggleButton.anchorView(top: nil, bottom: nil, leading: nil, trailing: nil, centerY: centerYAnchor, centerX: centerXAnchor, padding: .zero, size: .zero)
		messageButton.anchorView(top: nil, bottom: nil, leading: leadingAnchor, trailing: nil, centerY: centerYAnchor, centerX: nil, padding: UIEdgeInsets(top: 0.0, left: 20.0, bottom: 0.0, right: 0.0), size: iconSize)
		
		scrollView.anchorView(top: topAnchor, bottom: toggleButton.topAnchor, leading: leadingAnchor, trailing: trailingAnchor, centerY: nil, centerX: nil, padding: .zero, size: .zero)
		scrollView.contentSize = CGSize(width: contentSize * 4, height: 0.0)
		
		sosLabel.anchorView(top: scrollView.topAnchor, bottom: scrollView.bottomAnchor, leading: nil, trailing: nil, centerY: nil, centerX: scrollView.centerXAnchor, padding: .zero, size: CGSize(width: contentSize, height: 0.0))
		
		messageLabel.anchorView(top: scrollView.topAnchor, bottom: scrollView.bottomAnchor, leading: sosLabel.trailingAnchor, trailing: nil, centerY: nil, centerX: nil, padding: .zero, size: CGSize(width: contentSize, height: 0.0))
		
		conversionLabel.anchorView(top: scrollView.topAnchor, bottom: scrollView.bottomAnchor, leading: messageLabel.trailingAnchor, trailing: nil, centerY: nil, centerX: nil, padding: .zero, size: CGSize(width: contentSize, height: 0.0))
		
		switchLabel.anchorView(top: scrollView.topAnchor, bottom: scrollView.bottomAnchor, leading: conversionLabel.trailingAnchor, trailing: nil, centerY: nil, centerX: nil, padding: .zero, size: CGSize(width: contentSize, height: 0.0))
		holdLabel.anchorView(top: scrollView.topAnchor, bottom: scrollView.bottomAnchor, leading: switchLabel.trailingAnchor, trailing: nil, centerY: nil, centerX: nil, padding: .zero, size: CGSize(width: contentSize, height: 0.0))
		
		rightTapArea.anchorView(top: topAnchor, bottom: toggleButton.topAnchor, leading: centerXAnchor, trailing: trailingAnchor, centerY: nil, centerX: nil, padding: UIEdgeInsets(top: 0.0, left: 0.0, bottom: -20, right: 0.0), size: .zero)
		leftTapArea.anchorView(top: topAnchor, bottom: toggleButton.topAnchor, leading: leadingAnchor, trailing: centerXAnchor, centerY: nil, centerX: nil, padding: UIEdgeInsets(top: 0.0, left: 0.0, bottom: -20, right: 0.0), size: .zero)
	}
	
	// MARK: - Toggle Button
	func handleToggleButton(state: Bool) {
		buttonToggleState = state
	}
	
	func updateButtonColor(state: Bool) {
		if (state) {
			buttonShapeLayer.fillColor = Theme.Indicator.dim.cgColor
			buttonShapeLayer.strokeColor = Theme.Indicator.dim.cgColor
			buttonShapeOutline.strokeColor = Theme.Indicator.dim.cgColor
		} else {
			buttonShapeLayer.fillColor = Theme.Indicator.flashing.cgColor
			buttonShapeLayer.strokeColor = Theme.Indicator.flashing.cgColor
			buttonShapeOutline.strokeColor = Theme.Indicator.flashing.cgColor
		}
	}
	
	// MARK: - Handlers
	@objc func handleMessage() {
		// fade in textview
		
		guard let messageField = viewController?.mainView.topContainer.messageField else { return }
		messageField.backgroundColor = UIColor.white.adjust(by: -70.0)!
		messageField.isEditable = true
		messageField.isHidden = false
		messageField.becomeFirstResponder()
	}
	
	@objc func handleLeftArea() {
		scrollFlashTypeWithTouch(direction: .left)
	}
	
	@objc func handleRightArea() {
		scrollFlashTypeWithTouch(direction: .right)
	}
	
	@objc func handleToggle() {
		if (toggleButton.isEnabled) {
			ImpactFeedbackService.shared.impactType(feedBackStyle: .rigid)
			switch currState {
				case .kSos:
					viewController?.toggleSos()
				case .kMessage:
					()
				case .kSwitch:
					viewController?.toggleLight()
				case .kHold:
					()
				case .kConversion:
					viewModel?.convertMessageMode()
			}
		}
	}
	
	@objc func handleSideSwitch() {
		viewController?.switchSide()
	}
	
	@objc func handleLongPress(gesture: UILongPressGestureRecognizer) {
		viewController?.holdLight(state: .kOn)
		
		if (gesture.state == .ended) {
			viewController?.holdLight(state: .kOff)
		}
	}
	
	func handleMessageButtonState() {
		if (currIndex == MorseCodeMode.kMessage.rawValue) {
			guard let viewController = viewController else { return }
			if (viewController.mainView.topContainer.messageField.text.isEmpty) {
				buttonToggleState = false
			} else {
				buttonToggleState = true
			}
			
			UIView.animate(withDuration: 0.2, delay: 0.0, options: [.curveEaseInOut], animations: {
				self.messageButton.alpha = 1.0
				self.messageButton.isEnabled = true
			}) { (_) in
				//
			}
		} else {
			UIView.animate(withDuration: 0.2, delay: 0.0, options: [.curveEaseInOut], animations: {
				self.messageButton.alpha = 0.3
				self.messageButton.isEnabled = false
			}) { (_) in
				//
			}
			buttonToggleState = true
		}
	}
	
	// MARK: - Horizontal Swipe UI Logic
	// to switch between morse code modes
	@objc func handleHorizontalGestureRecognizer(gesture: UIPanGestureRecognizer) {
		viewController?.resetLight()
	}
	
	// horizontal swipe gesture
	override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
		let pan = gestureRecognizer as! UIPanGestureRecognizer
		let translation = pan.translation(in: self)
		let leftDetection = translation.x <= 0
		let rightDetection = translation.x >= 0
		
		
		// turn off light
		viewController?.resetLight()
		
		if (leftDetection && currIndex != MorseCodeMode.allCases.count - 1) {
			gestureRecognizer.isEnabled = false
			currIndex = Int((scrollView.contentOffset.x / contentSize)) + 1
			scrollView.setContentOffset(CGPoint(x: scrollView.contentOffset.x + contentSize, y: scrollView.contentOffset.y), animated: true)
		} else if (rightDetection && currIndex != 0) {
			gestureRecognizer.isEnabled = false
			currIndex = Int((scrollView.contentOffset.x / contentSize)) - 1
			scrollView.setContentOffset(CGPoint(x: scrollView.contentOffset.x - contentSize, y: scrollView.contentOffset.y), animated: true)
		}
		
		
		// enable/disable the Loop button
		if currIndex >= 2 {
			UIView.animate(withDuration: 0.1, animations: {
				self.viewController?.mainView.topContainer.loopButton.isEnabled = false
			})
			
		} else {
			UIView.animate(withDuration: 0.1, animations: {
				self.viewController?.mainView.topContainer.loopButton.isEnabled = true
			})
		}
		
		// hide/show the conversion view
		if (currIndex == MorseCodeMode.kConversion.rawValue) {
			
			self.viewController?.mainView.topContainer.frontCircleIndicator.isHidden = true
			self.viewController?.mainView.topContainer.conversionView.isHidden = false
			UIView.animate(withDuration: 0.1, animations: {
				self.viewController?.mainView.topContainer.conversionView.alpha = 1.0
			})
		} else {
			self.viewController?.mainView.topContainer.frontCircleIndicator.isHidden = false
			self.viewController?.mainView.topContainer.conversionView.isHidden = true
			UIView.animate(withDuration: 0.1, animations: {
				self.viewController?.mainView.topContainer.conversionView.alpha = 0.0
			})
		}
		
		updateCurrentFlashState()
		
		// disable message button
		handleMessageButtonState()

		
		
		// handle the gesture for a long press
		manageLongGestureRecognizer()
		return true
	}
	
	func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
		horizontalSwipeGesture.isEnabled = true
		scrollView.isUserInteractionEnabled = true
	}
	
	func createLongGestureRecognizer() -> UILongPressGestureRecognizer {
		let gesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress))
		gesture.minimumPressDuration = 0.01
		return gesture
	}
	
	// MARK: -  Touch scrolling
	func scrollFlashTypeWithTouch(direction: TapDirection) {
		scrollView.isUserInteractionEnabled = false
		// turn off light
		viewController?.resetLight()
		
		if (direction == .right && currIndex != MorseCodeMode.allCases.count) {
			currIndex = Int((scrollView.contentOffset.x / contentSize)) + 1
			scrollView.setContentOffset(CGPoint(x: scrollView.contentOffset.x + contentSize, y: scrollView.contentOffset.y), animated: true)
		} else if (direction == .left && currIndex != 0) {
			currIndex = Int((scrollView.contentOffset.x / contentSize)) - 1
			scrollView.setContentOffset(CGPoint(x: scrollView.contentOffset.x - contentSize, y: scrollView.contentOffset.y), animated: true)
		}
		
		// hide the Loop button
		if currIndex >= 2 {
			UIView.animate(withDuration: 0.1, animations: {
				self.viewController?.mainView.topContainer.loopButton.isEnabled = false
			})
			
		} else {
			UIView.animate(withDuration: 0.1, animations: {
				self.viewController?.mainView.topContainer.loopButton.isEnabled = true
			})
		}
		
		// hide/show the conversion view
		if (currIndex == MorseCodeMode.kConversion.rawValue) {
			
			self.viewController?.mainView.topContainer.frontCircleIndicator.isHidden = true
			self.viewController?.mainView.topContainer.conversionView.isHidden = false
			UIView.animate(withDuration: 0.1, animations: {
				self.viewController?.mainView.topContainer.conversionView.alpha = 1.0
			})
		} else {
			self.viewController?.mainView.topContainer.frontCircleIndicator.isHidden = false
			self.viewController?.mainView.topContainer.conversionView.isHidden = true
			UIView.animate(withDuration: 0.1, animations: {
				self.viewController?.mainView.topContainer.conversionView.alpha = 0.0
			})
		}
		
		updateCurrentFlashState()
		
		// disable message button
		handleMessageButtonState()
		
		// handle the gesture for a long press
		manageLongGestureRecognizer()
	}
	
	func updateCurrentFlashState() {
		currState = MorseCodeMode.init(rawValue: currIndex) ?? MorseCodeMode.init(rawValue: 0)!
	}
	
	// long gesture recognizer allows the light to be switched hold for as long as the user holds the button or until the phone runs out of battery....
	func manageLongGestureRecognizer() {
		switch currState {
			case .kSwitch, .kMessage, .kSos, .kConversion:
				if (!(toggleButton.gestureRecognizers?.isEmpty ?? true)) {
					toggleButton.removeGestureRecognizer((toggleButton.gestureRecognizers?.first)!)
				}
			case .kHold:
				toggleButton.addGestureRecognizer(createLongGestureRecognizer())
		}
	}
}
