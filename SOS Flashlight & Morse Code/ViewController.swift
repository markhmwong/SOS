//
//  ViewController.swift
//  SOS Flashlight & Morse Code
//
//  Created by Mark Wong on 6/5/20.
//  Copyright © 2020 Mark Wong. All rights reserved.
//

import UIKit
import AVFoundation

enum FlashFacingSide: Int {
	case rear // LED
	case front // SCREEN
}

class ViewController: UIViewController {

	private var frontScreenFlashView: UIView = {
		let view = UIView()
		view.backgroundColor = Theme.FrontScreenFlash.dim
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
		view.translatesAutoresizingMaskIntoConstraints = false
		return view
	}()
	
	var viewModel: ViewControllerViewModel?
	
	private let light = Flashlight()
		
	private var stateMachine: MorseStateMachineSystem?
	
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
		light.toggleTorch(on: false)
		
//		let parser = MorseParser(message: "SOS")
//		stateMachine = MorseStateMachineSystem(morseParser: parser, delegate: self)
//		stateMachine?.startSystemAtIdle()
		
		mainView.setupView()
	}
	
	override func viewWillLayoutSubviews() {
		super.viewWillLayoutSubviews()
		
	}
	
	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
	}
	
	func toggleSos() {
		let parser = MorseParser(message: "SOS")
		stateMachine = MorseStateMachineSystem(morseParser: parser, delegate: self)
		stateMachine?.startSystemAtIdle()
	}
	
	// always turn light off
	func resetLight() {
		light.toggleTorch(on: false)
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

		viewModel.kLightState = state.truthValueForState
		
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
				mainView.topContainer.updateSideLabel("FRONT SCREEN")
				viewModel.flashFacingSideState = .front
			case .front:
				mainView.topContainer.updateSideLabel("REAR FLASH")
				viewModel.flashFacingSideState = .rear
		}
	}
	
	func updateFrontScreenFlash(state: Bool) {
		guard let viewModel = viewModel else { return }

		viewModel.kFrontLightState = state
		DispatchQueue.main.async {
			self.frontScreenFlashView.backgroundColor = viewModel.kFrontLightState ? Theme.FrontScreenFlash.flashing : Theme.FrontScreenFlash.dim
		}
	}
}

extension ViewController: MorseStateMachineSystemDelegate {
	func willLoop() {
		
	}
	
	
	func willBreak() {
		
	}
	
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
				mainView.bottomContainer.updateButtonColor(state: false)

			case .dash, .dot:
				viewModel.kLightState = true
				if (viewModel.flashFacingSideState == .front) {
					updateFrontScreenFlash(state: true)
				} else {
					light.toggleTorch(on: true)

				}
				mainView.bottomContainer.updateButtonColor(state: true)
		}
	}
	
	func didFlash(type: MorseType) {
		
	}
	
	func didEnd() {
		mainView.bottomContainer.handleToggleButton(state: true)
	}
	
	func start() {
		mainView.bottomContainer.handleToggleButton(state: false)
	}
	
	func showSharePanel(text: String) {
		coordinator?.showShare(textToShare: text)
	}
}


