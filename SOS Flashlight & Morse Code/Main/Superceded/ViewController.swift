//
//  ViewController.swift
//  SOS Flashlight & Morse Code
//
//  Created by Mark Wong on 6/5/20.
//  Copyright © 2020 Mark Wong. All rights reserved.
//

import UIKit
import AVFoundation



final class Once {
	private var version: String = KeychainWrapper.standard.string(forKey: "com.whizbang.sos.appversion") ?? "1.0"
	
	func run(action: () -> Void) {
		// handle new version
		if (version != Whizbang.appVersion ?? "1.0") {
			action()
			KeychainWrapper.standard.set(Whizbang.appVersion ?? "1.0", forKey: "com.whizbang.sos.appversion")
		}
	}
}

class ViewController: UIViewController {

	private let once = Once()
	
	private var frontScreenFlashView: UIView = {
		let view = UIView()
		view.backgroundColor = Theme.mainBackground
		view.translatesAutoresizingMaskIntoConstraints = false
		return view
	}()
	
	lazy var mainView: MorseCodeView = {
		guard let viewModel = viewModel else {
			let viewModel = ViewControllerViewModel(viewController: self)
			let view = MorseCodeView(viewModel: viewModel, viewController: self)
			view.translatesAutoresizingMaskIntoConstraints = false
			return view
		}
		let view = MorseCodeView(viewModel: viewModel, viewController: self)
		view.backgroundColor = UIColor.clear
		view.translatesAutoresizingMaskIntoConstraints = false
		return view
	}()
	
	var viewModel: ViewControllerViewModel?
	
	private let light = Flashlight()
		
	private var stateMachine: MorseCodeStateMachineSystem? = nil
	
	private var readNextLetter: TimeInterval = 0.0
	
	private var remainingTime: TimeInterval = 0.0
		
	private var timeTillExpired: TimeInterval = 0.0

	private var coordinator: MainCoordinator? = nil
	
	init(coordinator: MainCoordinator) {
		self.coordinator = coordinator
		super.init(nibName: nil, bundle: nil)
	}
	
	required init?(coder: NSCoder) {
		super.init(coder: coder)
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)

		view.addSubview(frontScreenFlashView)
		view.addSubview(mainView)

		mainView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
		mainView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
		mainView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
		mainView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
		
		frontScreenFlashView.anchorView(top: view.topAnchor, bottom: view.bottomAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor, centerY: nil, centerX: nil, padding: UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0), size: .zero)
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		AppStoreReviewManager.requestReviewIfAppropriate()

		light.toggleTorch(on: false)
		mainView.setupView()
		//check if new version
		once.run {
			coordinator?.showSeizureWarning()
		}
	}
	
	// MARK: - Toggle Light whether it's by a short burst SOS, a Message, a switch or hold
	func toggleSos() {
		if (stateMachine != nil) {
			shutDownStateMachine()
		} else {
			let parser = MorseParser(message: "SOS")
			stateMachine = MorseCodeStateMachineSystem(morseParser: parser, delegate: self)
			guard let stateMachine = stateMachine, let viewModel = viewModel else { return }
			stateMachine.loopState = viewModel.loopState
			stateMachine.startSystemAtIdle()
		}
	}
	
	func toggleMessage() {
		if (stateMachine != nil) {
			shutDownStateMachine()
		} else {
			if let message = viewModel?.message, message != "" {
				let parser = MorseParser(message: message)
				stateMachine = MorseCodeStateMachineSystem(morseParser: parser, delegate: self)
				guard let stateMachine = stateMachine, let viewModel = viewModel else { return }
				stateMachine.loopState = viewModel.loopState
				stateMachine.startSystemAtIdle()
			} else {
				coordinator?.showError(error: TextFieldError.empty)
				ImpactFeedbackService.shared.failedFeedback()
			}
		}
	}
	
	// always turn light off
	func resetLight() {
		self.light.toggleTorch(on: false)
		self.mainView.topContainer.updateFrontIndicator(Theme.Indicator.dim.cgColor)
	}
	
	// binary state
	func toggleLight() {
		guard let viewModel = viewModel else { return }
		viewModel.kLightState = !viewModel.kLightState
		switch viewModel.flashFacingSideState {
			case .rear:
				light.toggleTorch(on: viewModel.kLightState)
			case .front:
				updateFrontScreenFlash(state: viewModel.kLightState)
				mainView.bottomContainer.updateButtonColor(state: viewModel.kLightState)
		}
	}
	
	func holdLight(state: LightState) {
		guard let viewModel = viewModel else { return }

		viewModel.kLightState = state.currentStatus
		
		switch viewModel.flashFacingSideState {
			case .rear:
				light.toggleTorch(on: viewModel.kLightState)
			case .front:
				updateFrontScreenFlash(state: viewModel.kLightState)
				mainView.bottomContainer.updateButtonColor(state: viewModel.kLightState)
		}
	}
	
	func switchSide() {
		guard let viewModel = viewModel else { return }

		switch viewModel.flashFacingSideState {
			case .rear:
				mainView.topContainer.updateSideLabel("Front")
				viewModel.flashFacingSideState = .front
			case .front:
				mainView.topContainer.updateSideLabel("Rear")
				viewModel.flashFacingSideState = .rear
		}
	}

	func updateFrontScreenFlash(state: Bool) {
		guard let viewModel = viewModel else { return }

		viewModel.kFrontLightState = state
		DispatchQueue.main.async {
			self.frontScreenFlashView.backgroundColor = viewModel.kFrontLightState ? Theme.mainBackgrounInverse : Theme.mainBackground
		}
	}
	
	func shutDownStateMachine() {
		light.toggleTorch(on: false)
		guard let stateMachine = stateMachine else {
			return
		}
		stateMachine.endTimer()
		self.stateMachine = nil
	}
	
	// Navigation methods
	func showSettings() {
		coordinator?.showSettings()
	}
	
	func showSharePanel(text: String) {
		coordinator?.showShare(textToShare: text)
	}
}

extension ViewController: MorseStateMachineSystemDelegate {
	// Right before the state machine begins to loop.
	func willLoop() {
		guard let viewModel = viewModel, let stateMachine = stateMachine else { return }
		stateMachine.loopState = viewModel.loopState
	}
	
	func willBreak() {
		// Do nothing
	}
	
	// Right before the device will cast the flash
	func willFlash(type: MorseType) {
		guard let viewModel = viewModel else { return }
		switch type {
			case .breakBetweenLetters, .breakBetweenWords, .breakBetweenPartsOfLetter, .none:
				viewModel.kLightState = false
				if (viewModel.flashFacingSideState == .front) {
					updateFrontScreenFlash(state: false)
				} else {
					light.toggleTorch(on: false)
				}
			case .dash, .dot:
				viewModel.kLightState = true
				if (viewModel.flashFacingSideState == .front) {
					updateFrontScreenFlash(state: true)
				} else {
					light.toggleTorch(on: true)
				}
		}
	}
	
	func didFlash(type: MorseType) {
		
	}
	
	// State machine ends
	func didEnd() {
		shutDownStateMachine()
	}
	
	// State machine begins
	func start() {
		stateMachine?.endTimer()
	}
}


