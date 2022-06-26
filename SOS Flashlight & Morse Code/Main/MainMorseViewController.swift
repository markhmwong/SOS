//
//  MorseMainViewController.swift
//  SOS Flashlight & Morse Code
//
//  Created by Mark Wong on 18/6/2022.
//  Copyright © 2022 Mark Wong. All rights reserved.
//

import UIKit

class MainMorseViewController: UIViewController, UICollectionViewDelegate {
    
    private var viewModel: MainMorseViewModel
  
    var mainContentCollectionView: UICollectionView! = nil
    
    var menuBar: MenuBar! = nil
    
    private var coordinator: MainCoordinator

    private var stateMachine: MorseCodeStateMachineSystem? = nil

    lazy var toggleButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(handleToggle), for: .touchDown)
        let config = UIImage.SymbolConfiguration(pointSize: UIScreen.main.bounds.height / 20, weight: .bold, scale: .large)
        let image = UIImage(systemName: "bolt.circle.fill", withConfiguration: config)
        button.setImage(image, for: .normal)
        button.tintColor = .defaultText
        button.backgroundColor = .clear
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var facingButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(handleFacingSide), for: .touchDown)
        let config = UIImage.SymbolConfiguration(pointSize: UIScreen.main.bounds.height / 50, weight: .bold, scale: .large)
        let image = UIImage(systemName: "arrow.triangle.2.circlepath", withConfiguration: config)
        button.setImage(image, for: .normal)
        button.tintColor = .defaultText
        button.backgroundColor = .clear
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var facingLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Front"
        label.font = UIFont.preferredFont(forTextStyle: .caption1)
        label.textColor = UIColor.defaultText
        return label
    }()
    
    var longPress: UILongPressGestureRecognizer! =  nil
    
    private var toolModeObserver: NSKeyValueObservation? = nil

    private var facingSideObserver: NSKeyValueObservation? = nil

    init(viewModel: MainMorseViewModel, coordinator: MainCoordinator) {
        self.coordinator = coordinator
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let settings = UIBarButtonItem(image: UIImage(systemName: "gearshape.2.fill"), style: .plain, target: self, action: #selector(showSettings))
        settings.tintColor = UIColor.defaultText
        navigationItem.leftBarButtonItem = settings
        let tipJar = UIBarButtonItem().tipJarButton(target: self, action: #selector(showTipJar))
        navigationItem.rightBarButtonItem = tipJar

        self.setupUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        AppStoreReviewManager.requestReviewIfAppropriate()
        viewModel.flashlight.toggleTorch(on: false)
    }
    
    @objc func showSettings() {
        coordinator.showSettings()
    }
    
    @objc func showTipJar() {
        coordinator.showTipJar()
    }
    
    func setupUI() {
        menuBar = MenuBar(vc: self, flashlight: viewModel.flashlight)
        mainContentCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout().fullScreenLayoutWithHorizontalBar(itemSpace: .zero, groupSpacing: .zero, cellHeight: NSCollectionLayoutDimension.fractionalHeight(1.0), menuBar: menuBar))
        mainContentCollectionView.translatesAutoresizingMaskIntoConstraints = false
        mainContentCollectionView.backgroundColor = UIColor.mainBackground
        mainContentCollectionView.isScrollEnabled = true
        mainContentCollectionView.delegate = self

        view.backgroundColor = UIColor.mainBackground
        view.addSubview(mainContentCollectionView)
        view.addSubview(menuBar)
        view.addSubview(toggleButton)
        view.addSubview(facingButton)
        view.addSubview(facingLabel)
        
        menuBar.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        menuBar.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        menuBar.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        menuBar.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height / 15).isActive = true
        
        mainContentCollectionView.topAnchor.constraint(equalTo: menuBar.bottomAnchor).isActive = true
        mainContentCollectionView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        mainContentCollectionView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        mainContentCollectionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        
        viewModel.configureDataSource(collectionView: mainContentCollectionView)
        
        toggleButton.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        toggleButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        toggleButton.contentEdgeInsets = UIEdgeInsets(top: 25.0, left: 15.0, bottom: 25.0, right: 15.0)
        toggleButton.layer.cornerRadius = toggleButton.bounds.height / 3
        
        facingButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30).isActive = true
        facingButton.centerYAnchor.constraint(equalTo: toggleButton.centerYAnchor).isActive = true
        
        facingLabel.topAnchor.constraint(equalTo: facingButton.bottomAnchor).isActive = true
        facingLabel.centerXAnchor.constraint(equalTo: facingButton.centerXAnchor).isActive = true
        
        facingLabel.text = viewModel.flashlight.facingSide.name
        
        longPress = createLongGestureRecognizer()
        
        // handle the gesture recogniser when the tool mode is pressed
        toolModeObserver = viewModel.flashlight.observe(\.observableToolMode, options: [.new]) { [weak self] flashlight, change in
            guard let newValue = change.newValue else { return }
            guard let self = self else { return }
            let mode = ToolLightMode.init(rawValue: newValue)
            
            switch mode {
            case .hold:
                self.toggleButton.addGestureRecognizer(self.longPress)
            case .toggle:
                self.toggleButton.removeGestureRecognizer(self.longPress)
            case .none:
                ()
            }
        }
        
        facingSideObserver = viewModel.flashlight.observe(\.observableFacingSide, options: [.new], changeHandler: { [weak self] flashlight, change in
            guard let newValue = change.newValue else { return }
            guard let self = self else { return }
            self.facingLabel.text =  FlashFacingSide.init(rawValue: newValue)?.name
            
        })
    }
    
    func handleToggleButton(state: Bool) {
        viewModel.buttonToggleState = state
    }
    
    @objc func handleFacingSide() {
        switch viewModel.flashlight.facingSide {
        case .rear:
            viewModel.flashlight.facingSide = .front
        case .front:
            viewModel.flashlight.facingSide = .rear
        }
    }
    
    func scrollToItem(indexPath: IndexPath) {
        mainContentCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }
    
    // MARK: - Toggle Light whether it's by a short burst SOS, a Message, a switch or hold
    func toggleSos() {
        if (stateMachine != nil) {
            shutDownStateMachine()
        } else {
            let parser = MorseParser(message: "SOS")
            stateMachine = MorseCodeStateMachineSystem(morseParser: parser, delegate: self)
            guard let stateMachine = stateMachine else { return }
            stateMachine.loopState = viewModel.loopState
            stateMachine.startSystemAtIdle()
        }
    }
    
    func toggleMessage() {
        
        if (stateMachine != nil) {
            shutDownStateMachine()
        } else {
            if viewModel.messageToFlashlight != "" {
                let parser = MorseParser(message: viewModel.messageToFlashlight)
                stateMachine = MorseCodeStateMachineSystem(morseParser: parser, delegate: self)
                guard let stateMachine = stateMachine else { return }
                stateMachine.loopState = viewModel.loopState
                stateMachine.startSystemAtIdle()
            } else {
                coordinator.showError(error: TextFieldError.empty)
                ImpactFeedbackService.shared.failedFeedback()
            }
        }
    }
    
    // binary state
    func toggleTools() {
        switch viewModel.flashlight.toolMode {
            case .toggle:
            switch viewModel.flashlight.facingSide {
            case .front:
                viewModel.flashlight.toggleTorch(on: !viewModel.flashlight.lightSwitch, side: viewModel.flashlight.facingSide)
            case .rear:
                viewModel.flashlight.toggleTorch(on: !viewModel.flashlight.lightSwitch)
            }
            case .hold:
            // toggled by handleLongPress under the gesture recogniser
            ()
        }
//        viewModel.kLightState = !viewModel.kLightState
//        switch viewModel.flashFacingSideState {
//            case .rear:
//                light.toggleTorch(on: viewModel.kLightState)
//            case .front:
//                updateFrontScreenFlash(state: viewModel.kLightState)
//                mainView.bottomContainer.updateButtonColor(state: viewModel.kLightState)
//        }
    }
    
    func createLongGestureRecognizer() -> UILongPressGestureRecognizer {
        let gesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress))
        gesture.minimumPressDuration = 0.01
        return gesture
    }
    
    private var longPressGesture: UILongPressGestureRecognizer = {
        let gesture = UILongPressGestureRecognizer(target: MainMorseViewController.self, action: #selector(handleLongPress))
        return gesture
    }()
    
    @objc func handleLongPress(gesture: UILongPressGestureRecognizer) {
        viewModel.flashlight.toggleTorch(on: true, side: viewModel.flashlight.facingSide)
        if (gesture.state == .ended) {
            viewModel.flashlight.toggleTorch(on: false, side: viewModel.flashlight.facingSide)
        }
    }
    
    func shutDownStateMachine() {
        viewModel.flashlight.toggleTorch(on: false)
        guard let stateMachine = stateMachine else {
            return
        }
        stateMachine.endTimer()
        self.stateMachine = nil
    }
    
    @objc func handleToggle() {
        if let mode = MainMorseViewModel.FlashLightMode.init(rawValue: mainContentCollectionView.indexPathsForVisibleItems.first?.item ?? .zero) {
            viewModel.flashlight.updateMode(mode: mode)
            
            if (toggleButton.isEnabled) {
                switch mode {
                case .sos:
                    ImpactFeedbackService.shared.impactType(feedBackStyle: .heavy)
                    toggleSos()
                case .messageConversion:
                    ImpactFeedbackService.shared.impactType(feedBackStyle: .heavy)
                    toggleMessage()
                case .tools:
                    ImpactFeedbackService.shared.impactType(feedBackStyle: .heavy)
                    toggleTools()
                case .morseConversion:
                    ImpactFeedbackService.shared.impactType(feedBackStyle: .heavy)
                    // message passed via notification center. Look up MESSAGE_TO_TEXT
                }
            }
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        shutDownStateMachine()
    }
}

extension MainMorseViewController: MorseStateMachineSystemDelegate {
    // Right before the state machine begins to loop.
    func willLoop() {
        guard let stateMachine = stateMachine else { return }
        stateMachine.loopState = viewModel.loopState
    }
    
    func willBreak() {
        // Do nothing
    }
    
    // Right before the device will cast the flash
    func willFlash(type: MorseType) {
        
        switch type {
            case .breakBetweenLetters, .breakBetweenWords, .breakBetweenPartsOfLetter, .none:
//                viewModel.kLightState = false
                if (viewModel.flashFacingSideState == .front) {
                    updateFrontScreenFlash(state: false)
                } else {
                    viewModel.flashlight.toggleTorch(on: false)
                }
            case .dash, .dot:
//                viewModel.kLightState = true
                if (viewModel.flashFacingSideState == .front) {
                    updateFrontScreenFlash(state: true)
                } else {
                    viewModel.flashlight.toggleTorch(on: true)
                }
        }
    }
    
    func updateFrontScreenFlash(state: Bool) {
//        viewModel.kFrontLightState = state
        print("update here")
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




