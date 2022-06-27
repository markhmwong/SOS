////
////  BottomContainerView.swift
////  SOS Flashlight & Morse Code
////
////  Created by Mark Wong on 14/5/20.
////  Copyright © 2020 Mark Wong. All rights reserved.
////
//
//import UIKit
//
//enum TextFieldError: Error {
//	case empty
//}
//
////MARK: - Bottom Container
//class BottomContainer: UIView, UIGestureRecognizerDelegate, UIScrollViewDelegate {
//
//	enum TapDirection {
//		case left
//		case right
//	}
//
//	private weak var viewModel: ViewControllerViewModel?
//
//	private weak var viewController: ViewController?
//
//	//move to viewModel
//	// MARK: - Class variables and states
//	private var contentSize: CGFloat = .zero
//
//	private var currIndex: Int
//
//	var currState: MorseCodeMode
//
//	var buttonToggleState: Bool = true {
//		didSet {
//			toggleButton.isEnabled = buttonToggleState
//			toggleButton.alpha = toggleButton.isEnabled ? 1.0 : 0.1
//		}
//	}
//
//	// MARK: - Views
//	lazy var leftTapArea: UIView = {
//		let view = UIView()
//		view.translatesAutoresizingMaskIntoConstraints = false
//		view.backgroundColor = .clear
//		return view
//	}()
//
//	lazy var rightTapArea: UIView = {
//		let view = UIView()
//		view.backgroundColor = .clear
//		view.translatesAutoresizingMaskIntoConstraints = false
//		return view
//	}()
//
//	lazy var scrollView: UIScrollView = {
//		let view = UIScrollView()
//		view.isScrollEnabled = false
//		view.delegate = self
//		view.showsHorizontalScrollIndicator = false
//		view.translatesAutoresizingMaskIntoConstraints = false
//		return view
//	}()
//
//	// MARK: - Buttons
//
//	lazy var toggleButton: UIButton = {
//		let button = UIButton()
//		button.accessibilityLabel = "Toggle Flash"
//		button.addTarget(self, action: #selector(handleToggle), for: .touchDown)
////		button.setAttributedTitle(NSMutableAttributedString().flashButtonTextAttributes(string: "Flash"), for: .normal)
//
//        let config = UIImage.SymbolConfiguration(pointSize: UIScreen.main.bounds.height / 20, weight: .bold, scale: .large)
//        let image = UIImage(systemName: "bolt.circle.fill", withConfiguration: config)
//
//        button.setImage(image, for: .normal)
//        button.tintColor = .black
//		button.layer.backgroundColor = Theme.Dark.FlashButton.background.cgColor
//		button.translatesAutoresizingMaskIntoConstraints = false
//		return button
//	}()
//
//	// MARK: - Gestures
//	private var longPressGesture: UILongPressGestureRecognizer = {
//		let gesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress))
//		return gesture
//	}()
//
//	private lazy var leftTapGesture: UITapGestureRecognizer = {
//		let gesture = UITapGestureRecognizer(target: self, action: #selector(handleLeftArea))
//		return gesture
//	}()
//
//	private lazy var rightTapGesture: UITapGestureRecognizer = {
//		let gesture = UITapGestureRecognizer(target: self, action: #selector(handleRightArea))
//		return gesture
//	}()
//
//	private lazy var horizontalSwipeGesture: UIPanGestureRecognizer = {
//		let gesture = UIPanGestureRecognizer(target: self, action: #selector(handleHorizontalGestureRecognizer))
//		gesture.maximumNumberOfTouches = 1
//		gesture.minimumNumberOfTouches = 1
//		gesture.delegate = self
//		return gesture
//	}()
//
//	// MARK: - Labels
//	private lazy var sosLabel: UILabel = {
//		let label = UILabel()
//		label.translatesAutoresizingMaskIntoConstraints = false
//		label.backgroundColor = .clear
//		label.textAlignment = .center
//		label.adjustsFontForContentSizeCategory = true
//		label.attributedText = NSMutableAttributedString().secondaryTitleAttributes(string: "SOS")
//		return label
//	}()
//
//	private lazy var messageLabel: UILabel = {
//		let label = UILabel()
//		label.translatesAutoresizingMaskIntoConstraints = false
//		label.backgroundColor = .clear
//		label.textAlignment = .center
//		label.attributedText = NSMutableAttributedString().secondaryTitleAttributes(string: "MESSAGE")
//		return label
//	}()
//
//	private lazy var conversionLabel: UILabel = {
//		let label = UILabel()
//		label.translatesAutoresizingMaskIntoConstraints = false
//		label.backgroundColor = .clear
//		label.textAlignment = .center
//		label.attributedText = NSMutableAttributedString().secondaryTitleAttributes(string: "CONVERSION")
//		return label
//	}()
//
//	lazy var switchLabel: UILabel = {
//		let label = UILabel()
//		label.backgroundColor = .clear
//		label.translatesAutoresizingMaskIntoConstraints = false
//		label.textAlignment = .center
//		label.attributedText = NSMutableAttributedString().secondaryTitleAttributes(string: "SWITCH")
//		return label
//	}()
//
//	lazy var holdLabel: UILabel = {
//		let label = UILabel()
//		label.backgroundColor = .clear
//		label.translatesAutoresizingMaskIntoConstraints = false
//		label.textAlignment = .center
//		label.attributedText = NSMutableAttributedString().secondaryTitleAttributes(string: "HOLD")
//		return label
//	}()
//
//	// MARK: - Shapes
//	private var buttonShapeLayer = CAShapeLayer()
//
//	private var buttonShapeOutline = CAShapeLayer()
//
//	init(viewModel: ViewControllerViewModel?, viewController: ViewController?) {
//		self.viewController = viewController
//		self.viewModel = viewModel
//		self.currIndex = 0
//		self.currState = MorseCodeMode.init(rawValue: currIndex) ?? MorseCodeMode.kMessage
//		super.init(frame: .zero)
//		self.translatesAutoresizingMaskIntoConstraints = false
//	}
//
//	required init?(coder: NSCoder) {
//		self.currIndex = 0
//		self.currState = MorseCodeMode.init(rawValue: currIndex) ?? MorseCodeMode.kMessage
//		super.init(coder: coder)
//	}
//
//	// MARK: - Setup view
//	func setupView() {
//		addSubview(scrollView)
//
//		//taps area
//		leftTapArea.addGestureRecognizer(leftTapGesture)
//		rightTapArea.addGestureRecognizer(rightTapGesture)
//
//		addSubview(leftTapArea)
//		addSubview(rightTapArea)
//
//		addGestureRecognizer(horizontalSwipeGesture)
//		scrollView.addSubview(sosLabel)
//
//		scrollView.addSubview(messageLabel)
//		scrollView.addSubview(switchLabel)
//		scrollView.addSubview(holdLabel)
//		scrollView.addSubview(conversionLabel)
//
//		addSubview(toggleButton)
//
//		let path = UIBezierPath(arcCenter: .zero, radius: 25, startAngle: 0, endAngle: CGFloat.pi * 2, clockwise: true)
//		buttonShapeLayer = CAShapeLayer().circularShapeLayer(path: path.cgPath, color: UIColor.white.cgColor, fillColor: UIColor.white.cgColor, strokeEnd: 1, lineWidth: 5)
////		toggleButton.layer.addSublayer(buttonShapeLayer)
//
//		let outlinePath = UIBezierPath(arcCenter: .zero, radius: 35, startAngle: 0, endAngle: CGFloat.pi * 2, clockwise: true)
//		buttonShapeOutline = CAShapeLayer().circularShapeLayer(path: outlinePath.cgPath, color: UIColor.white.cgColor, fillColor: UIColor.clear.cgColor, strokeEnd: 1, lineWidth: 3)
////		toggleButton.layer.addSublayer(buttonShapeOutline)
//
//	}
//
//	// MARK: -  Constraints
//	override func layoutSubviews() {
//		super.layoutSubviews()
//		contentSize = bounds.width / 3.0
//
//		buttonShapeLayer.position = CGPoint(x: toggleButton.bounds.midX, y: toggleButton.bounds.midY)
//		buttonShapeOutline.position = CGPoint(x: toggleButton.bounds.midX, y: toggleButton.bounds.midY)
//
//		let iconSize = CGSize(width: bounds.width * 0.11, height: bounds.width * 0.11)
//
//		toggleButton.anchorView(top: nil, bottom: nil, leading: nil, trailing: nil, centerY: centerYAnchor, centerX: centerXAnchor, padding: .zero, size: .zero)
//		toggleButton.contentEdgeInsets = UIEdgeInsets(top: 25.0, left: 15.0, bottom: 25.0, right: 15.0)
//		toggleButton.layer.cornerRadius = toggleButton.bounds.height / 3
//		scrollView.anchorView(top: topAnchor, bottom: toggleButton.topAnchor, leading: leadingAnchor, trailing: trailingAnchor, centerY: nil, centerX: nil, padding: .zero, size: .zero)
//		scrollView.contentSize = CGSize(width: contentSize * 4, height: 0.0)
//
//		sosLabel.anchorView(top: scrollView.topAnchor, bottom: scrollView.bottomAnchor, leading: nil, trailing: nil, centerY: nil, centerX: scrollView.centerXAnchor, padding: .zero, size: CGSize(width: contentSize, height: 0.0))
//
//		messageLabel.anchorView(top: scrollView.topAnchor, bottom: scrollView.bottomAnchor, leading: sosLabel.trailingAnchor, trailing: nil, centerY: nil, centerX: nil, padding: .zero, size: CGSize(width: contentSize, height: 0.0))
//
//		conversionLabel.anchorView(top: scrollView.topAnchor, bottom: scrollView.bottomAnchor, leading: messageLabel.trailingAnchor, trailing: nil, centerY: nil, centerX: nil, padding: .zero, size: CGSize(width: contentSize, height: 0.0))
//
//		switchLabel.anchorView(top: scrollView.topAnchor, bottom: scrollView.bottomAnchor, leading: conversionLabel.trailingAnchor, trailing: nil, centerY: nil, centerX: nil, padding: .zero, size: CGSize(width: contentSize, height: 0.0))
//		holdLabel.anchorView(top: scrollView.topAnchor, bottom: scrollView.bottomAnchor, leading: switchLabel.trailingAnchor, trailing: nil, centerY: nil, centerX: nil, padding: .zero, size: CGSize(width: contentSize, height: 0.0))
//
//		rightTapArea.anchorView(top: topAnchor, bottom: toggleButton.topAnchor, leading: centerXAnchor, trailing: trailingAnchor, centerY: nil, centerX: nil, padding: UIEdgeInsets(top: 0.0, left: 0.0, bottom: -20, right: 0.0), size: .zero)
//		leftTapArea.anchorView(top: topAnchor, bottom: toggleButton.topAnchor, leading: leadingAnchor, trailing: centerXAnchor, centerY: nil, centerX: nil, padding: UIEdgeInsets(top: 0.0, left: 0.0, bottom: -20, right: 0.0), size: .zero)
//	}
//
//	// MARK: - Toggle Button
//	func handleToggleButton(state: Bool) {
//		buttonToggleState = state
//	}
//
//	func updateButtonColor(state: Bool) {
//		if (state) {
//			buttonShapeLayer.fillColor = Theme.Indicator.dim.cgColor
//			buttonShapeLayer.strokeColor = Theme.Indicator.dim.cgColor
//			buttonShapeOutline.strokeColor = Theme.Indicator.dim.cgColor
//		} else {
//			buttonShapeLayer.fillColor = Theme.Indicator.flashing.cgColor
//			buttonShapeLayer.strokeColor = Theme.Indicator.flashing.cgColor
//			buttonShapeOutline.strokeColor = Theme.Indicator.flashing.cgColor
//		}
//	}
//
//	// MARK: - Button Handlers
//
//	@objc func handleLeftArea() {
//		scrollFlashTypeWithTouch(direction: .left)
//	}
//
//	@objc func handleRightArea() {
//		scrollFlashTypeWithTouch(direction: .right)
//	}
//
//	// handle main flash toggle button
//	@objc func handleToggle() {
//		if (toggleButton.isEnabled) {
//			switch currState {
//				case .kSos:
//					ImpactFeedbackService.shared.impactType(feedBackStyle: .heavy)
//					viewController?.toggleSos()
//				case .kMessage:
//					viewController?.toggleMessage()
//				case .kTool:
//					ImpactFeedbackService.shared.impactType(feedBackStyle: .heavy)
//					viewController?.toggleLight()
//					ImpactFeedbackService.shared.impactType(feedBackStyle: .heavy)
//				case .kConversion:
//					ImpactFeedbackService.shared.impactType(feedBackStyle: .soft)
//					viewModel?.convertMessageMode(text:	viewController?.mainView.topContainer.conversionField.text ?? "")
//			}
//		}
//	}
//
//	@objc func handleLongPress(gesture: UILongPressGestureRecognizer) {
//		viewController?.holdLight(state: .kOn)
//
//		if (gesture.state == .ended) {
//			viewController?.holdLight(state: .kOff)
//		}
//	}
//
//	func handleMessageButtonState() {
//		if (currIndex == MorseCodeMode.kMessage.rawValue) {
//			guard let viewController = viewController else { return }
//			if (viewController.mainView.topContainer.messageField.text.isEmpty) {
//				buttonToggleState = false
//			} else {
//				buttonToggleState = true
//			}
//		} else {
//
//			buttonToggleState = true
//		}
//	}
//
//	// MARK: - Bottom Menu Swipe Logic
//	// to switch between morse code modes
//	@objc func handleHorizontalGestureRecognizer(gesture: UIPanGestureRecognizer) {
//		viewController?.resetLight()
//	}
//
//	// horizontal swipe gesture
//	override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
//		let pan = gestureRecognizer as! UIPanGestureRecognizer
//		let translation = pan.translation(in: self)
//		let leftDetection = translation.x <= 0
//		let rightDetection = translation.x >= 0
//
//		// turn off light
//		viewController?.resetLight()
//
//		viewController?.shutDownStateMachine()
//
//		if (leftDetection && currIndex != MorseCodeMode.allCases.count - 1) {
//			gestureRecognizer.isEnabled = false
//			currIndex = Int((scrollView.contentOffset.x / contentSize)) + 1
//			scrollView.setContentOffset(CGPoint(x: scrollView.contentOffset.x + contentSize, y: scrollView.contentOffset.y), animated: true)
//		} else if (rightDetection && currIndex != 0) {
//			gestureRecognizer.isEnabled = false
//			currIndex = Int((scrollView.contentOffset.x / contentSize)) - 1
//			scrollView.setContentOffset(CGPoint(x: scrollView.contentOffset.x - contentSize, y: scrollView.contentOffset.y), animated: true)
//		}
//
//
//		// enable/disable the Loop button
//		if currIndex >= 2 {
//			UIView.animate(withDuration: 0.1, animations: {
//				self.viewController?.mainView.topContainer.loopButton.isEnabled = false
//			})
//
//		} else {
//			UIView.animate(withDuration: 0.1, animations: {
//				self.viewController?.mainView.topContainer.loopButton.isEnabled = true
//			})
//		}
//
//		// hide/show the conversion view
//		hideConversionView()
//
//		// hide/show message field
//		hideMessageField()
//
//		updateCurrentFlashState()
//
//		// disable message button
//		handleMessageButtonState()
//
//		// handle the gesture for a long press
//		manageLongGestureRecognizer()
//		return true
//	}
//
//	func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
//		horizontalSwipeGesture.isEnabled = true
//		scrollView.isUserInteractionEnabled = true
//	}
//
//	func createLongGestureRecognizer() -> UILongPressGestureRecognizer {
//		let gesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress))
//		gesture.minimumPressDuration = 0.01
//		return gesture
//	}
//
//	// MARK: -  Bottom Menu Touch Response
//	func scrollFlashTypeWithTouch(direction: TapDirection) {
//		scrollView.isUserInteractionEnabled = false
//
//		// turn off light
//		viewController?.resetLight()
//
//		viewController?.shutDownStateMachine()
//
//		// control the direction and handle edge case
//
//		if (direction == .right && currIndex < MorseCodeMode.allCases.count - 1) {
//			currIndex = Int((scrollView.contentOffset.x / contentSize)) + 1
//			scrollView.setContentOffset(CGPoint(x: scrollView.contentOffset.x + contentSize, y: scrollView.contentOffset.y), animated: true)
//		} else if (direction == .left && currIndex != 0) {
//			currIndex = Int((scrollView.contentOffset.x / contentSize)) - 1
//			scrollView.setContentOffset(CGPoint(x: scrollView.contentOffset.x - contentSize, y: scrollView.contentOffset.y), animated: true)
//		}
//
//		// hide the Loop button
//		if currIndex >= MorseCodeMode.kConversion.rawValue {
//			UIView.animate(withDuration: 0.1, animations: {
//				self.viewController?.mainView.topContainer.loopButton.isEnabled = false
//			})
//
//		} else {
//			UIView.animate(withDuration: 0.1, animations: {
//				self.viewController?.mainView.topContainer.loopButton.isEnabled = true
//			})
//		}
//
//		hideConversionView()
//
//		// hide message box for Message Mode
//		hideMessageField()
//
//		updateCurrentFlashState()
//
//		// disable message button
//		handleMessageButtonState()
//
//		// handle the gesture for a long press
//		manageLongGestureRecognizer()
//	}
//
//	func hideConversionView() {
//		// hide/show the conversion view
//		if (currIndex == MorseCodeMode.kConversion.rawValue) {
//			self.viewController?.mainView.topContainer.frontCircleIndicator.isHidden = true
//			self.viewController?.mainView.topContainer.conversionView.isHidden = false
//
//            let config = UIImage.SymbolConfiguration(pointSize: UIScreen.main.bounds.height / 20, weight: .bold, scale: .large)
//            let image = UIImage(systemName: "textformat.size", withConfiguration: config)
//            toggleButton.setImage(image, for: .normal)
//			UIView.animate(withDuration: 0.1, animations: {
//				self.viewController?.mainView.topContainer.conversionView.alpha = 1.0
//			})
//		} else {
//			self.viewController?.mainView.topContainer.frontCircleIndicator.isHidden = false
//			self.viewController?.mainView.topContainer.conversionView.isHidden = true
//			UIView.animate(withDuration: 0.1, animations: {
//				self.viewController?.mainView.topContainer.conversionView.alpha = 0.0
//			})
//            let config = UIImage.SymbolConfiguration(pointSize: UIScreen.main.bounds.height / 20, weight: .bold, scale: .large)
//            let image = UIImage(systemName: "bolt.circle.fill", withConfiguration: config)
//            toggleButton.setImage(image, for: .normal)
//		}
//	}
//
//	func hideMessageField() {
//		// hide message box for Message Mode
//		if (currIndex != MorseCodeMode.kMessage.rawValue) {
//			self.viewController?.mainView.topContainer.messageContainer.isHidden = true
//			self.viewController?.mainView.topContainer.messageField.isEditable = false
//		} else {
//			self.viewController?.mainView.topContainer.messageContainer.isHidden = false
//			self.viewController?.mainView.topContainer.messageField.isEditable = true
//		}
//	}
//
//	func updateCurrentFlashState() {
//		currState = MorseCodeMode.init(rawValue: currIndex) ?? MorseCodeMode.init(rawValue: 0)!
//	}
//
//	// long gesture recognizer allows the light to be switched hold for as long as the user holds the button or until the phone runs out of battery....
//	func manageLongGestureRecognizer() {
//		switch currState {
//			case .kMessage, .kSos, .kConversion:
//				if (!(toggleButton.gestureRecognizers?.isEmpty ?? true)) {
//					toggleButton.removeGestureRecognizer((toggleButton.gestureRecognizers?.first)!)
//				}
//        case .kTool:
//				toggleButton.addGestureRecognizer(createLongGestureRecognizer())
//		}
//	}
//
//	// MARK: - Trait
//	override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
//        sosLabel.sizeToFit()
//    }
//}
