//
//  MorseMainViewController.swift
//  SOS Flashlight & Morse Code
//
//  Created by Mark Wong on 18/6/2022.
//  Copyright © 2022 Mark Wong. All rights reserved.
//

import UIKit
import TelemetryClient
import GoogleMobileAds

class MainMorseViewController: UIViewController, UICollectionViewDelegate {
    
    private var viewModel: MainMorseViewModel
  
    var mainContentCollectionView: UICollectionView! = nil
    
    var menuBar: MenuBar! = nil
    
    private var coordinator: MainCoordinator

    private var stateMachine: MorseCodeStateMachineSystem? = nil

    private var  bannerView: GADBannerView!
    
    lazy var mainToggleButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(handleToggle), for: .touchDown)
        let config = UIImage.SymbolConfiguration(pointSize: UIScreen.main.bounds.height / 27, weight: .bold, scale: .large)
        let image = UIImage(systemName: "bolt.circle.fill", withConfiguration: config)
        button.setImage(image, for: .normal)
        button.tintColor = .defaultText
        button.backgroundColor = .clear
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var holdToLockLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Hold to lock"
        label.layer.opacity = 0.0
        label.font = UIFont.preferredFont(forTextStyle: .caption1)
        return label
    }()
    
    lazy var facingButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(handleFacingSide), for: .touchDown)
        let config = UIImage.SymbolConfiguration(pointSize: UIScreen.main.bounds.height / 60, weight: .bold, scale: .large)
        let image = UIImage(systemName: "square.bottomhalf.filled", withConfiguration: config)
        button.setImage(image, for: .normal)
        button.tintColor = .defaultText
        button.backgroundColor = .clear
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var facingLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Front" // front or rear
        label.font = UIFont.preferredFont(forTextStyle: .caption1)
        label.textColor = UIColor.defaultText
        return label
    }()
    
    lazy var loopingButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(handleLooping), for: .touchDown)
        let config = UIImage.SymbolConfiguration(pointSize: UIScreen.main.bounds.height / 60, weight: .bold, scale: .large)
        let image = UIImage(systemName: "arrow.triangle.2.circlepath", withConfiguration: config)
        button.setImage(image, for: .normal)
        button.tintColor = .defaultText
        button.backgroundColor = .clear
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
//    lazy var lockButton: UIButton = {
//        let button = UIButton()
//        button.addTarget(self, action: #selector(handleLock), for: .touchDown)
//        let config = UIImage.SymbolConfiguration(pointSize: UIScreen.main.bounds.height / 60, weight: .bold, scale: .large)
//        let image = UIImage(systemName: "lock.fill", withConfiguration: config)
//        button.setImage(image, for: .normal)
//        button.tintColor = .defaultText
//        button.backgroundColor = .clear
//        button.translatesAutoresizingMaskIntoConstraints = false
//        return button
//    }()
    
    lazy var lockImage: UIImageView = {
        let symbolConfig: UIImage.SymbolConfiguration = UIImage.SymbolConfiguration(font: UIFont.preferredFont(forTextStyle: .body))
        let image: UIImage = UIImage(systemName: "lock.fill",withConfiguration: symbolConfig)!
        let imageView: UIImageView = UIImageView(image: image)
        imageView.tintColor = .systemOrange
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.opacity = 0.0
        return imageView
    }()
    
    lazy var loopingLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Loop"
        label.font = UIFont.preferredFont(forTextStyle: .caption1)
        label.textColor = UIColor.defaultText
        return label
    }()
	
	private var liveViewController: LiveViewController
    
    var longPress: UILongPressGestureRecognizer! =  nil
    
    var lockGesture: UILongPressGestureRecognizer! =  nil

    private var toolModeObserver: NSKeyValueObservation? = nil

    private var modeObserver: NSKeyValueObservation? = nil

    private var facingSideObserver: NSKeyValueObservation? = nil

    init(viewModel: MainMorseViewModel, coordinator: MainCoordinator) {
        self.coordinator = coordinator
        self.viewModel = viewModel
		self.liveViewController = LiveViewController(viewModel: viewModel)
		super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func handleSavedMessages() {
        coordinator.showSavedMessages(cds: self.viewModel.cds)
    }
    
    @objc func handleRecentMessages() {
        coordinator.showRecentMessages(cds: self.viewModel.cds)
    }
    
    
    
    func handleLock() {
        viewModel.sosLock = !viewModel.sosLock
        loopingButton.isEnabled = !loopingButton.isEnabled
        facingButton.isEnabled = loopingButton.isEnabled

        if viewModel.sosLock {
//            DispatchQueue.main.async {
                self.lockImage.layer.opacity = 1.0
                self.facingLabel.layer.opacity = 1.0
//            }
            
        } else {
//            DispatchQueue.main.async {
                self.lockImage.layer.opacity = 0.4
                self.facingLabel.layer.opacity = 0.4
//            }
            
        }

        mainContentCollectionView.isScrollEnabled = loopingButton.isEnabled
        mainContentCollectionView.isUserInteractionEnabled = loopingButton.isEnabled
    }
    
    override func loadView() {
        super.loadView()
		self.setupUIV3()
        self.setupUI()
		
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
		
        mainContentCollectionView.isDirectionalLockEnabled = false
        mainContentCollectionView.isScrollEnabled = false
        mainContentCollectionView.showsVerticalScrollIndicator = false
        mainContentCollectionView.showsHorizontalScrollIndicator = false
		
        NotificationCenter.default.addObserver(self, selector: #selector(handleSavedMessages), name: .showSavedMessages, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleRecentMessages), name: .showRecentMessages, object: nil)
		
        let settings = UIBarButtonItem(image: UIImage(systemName: "gearshape.2.fill"), style: .plain, target: self, action: #selector(showSettings))
        settings.tintColor = UIColor.defaultText
        navigationItem.leftBarButtonItem = settings
        let tipJar = UIBarButtonItem().tipJarButton(target: self, action: #selector(showTipJar))
        let info = UIBarButtonItem(image: UIImage(systemName: "info.circle.fill"), style: .plain, target: self, action: #selector(showInfo))
        info.tintColor = UIColor.defaultText
        navigationItem.rightBarButtonItems = [tipJar, info]
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewModel.flashlight.toggleTorch(on: false)
        // Review must be declared here or it will not show
        AppStoreReviewManager.requestReviewIfAppropriate()
    }
    
    @objc func showSettings() {
        coordinator.showSettings()
    }
    
    @objc func showTipJar() {
        coordinator.showTipJar()
    }
    
	func setupUIV3() {

	}
	
    func setupUI() {
        menuBar = MenuBar(vc: self, flashlight: viewModel.flashlight)
        mainContentCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout().fullScreenLayoutWithHorizontalBar(itemSpace: .zero, groupSpacing: .zero, cellHeight: NSCollectionLayoutDimension.fractionalHeight(1.0), menuBar: menuBar))
        mainContentCollectionView.translatesAutoresizingMaskIntoConstraints = false
        mainContentCollectionView.backgroundColor = UIColor.mainBackground
        mainContentCollectionView.delegate = self
        
        view.backgroundColor = UIColor.mainBackground
        view.addSubview(mainContentCollectionView)
		
		// move back to setupUIV3 once initial testing is complete
		self.addChild(self.liveViewController)
		self.view.addSubview(self.liveViewController.view)
		
        view.addSubview(menuBar)
        view.addSubview(mainToggleButton)
        view.addSubview(facingButton)
        view.addSubview(facingLabel)
        view.addSubview(loopingButton)
        view.addSubview(loopingLabel)
        view.addSubview(lockImage)
        view.addSubview(holdToLockLabel)

        var holdToLockLabelConstraint = holdToLockLabel.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: 0)
        holdToLockLabelConstraint.constant = -70
        holdToLockLabelConstraint.isActive = true

        holdToLockLabel.centerXAnchor.constraint(equalTo: mainToggleButton.centerXAnchor).isActive = true
        
        lockImage.bottomAnchor.constraint(equalTo: mainToggleButton.topAnchor, constant: 0).isActive = true
        lockImage.centerXAnchor.constraint(equalTo: mainToggleButton.centerXAnchor).isActive = true
        
        menuBar.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        menuBar.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        menuBar.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        menuBar.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height / 12.5).isActive = true
        
        mainContentCollectionView.topAnchor.constraint(equalTo: menuBar.bottomAnchor, constant: 10).isActive = true
        mainContentCollectionView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        mainContentCollectionView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        mainContentCollectionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true

        viewModel.configureDataSource(collectionView: mainContentCollectionView)
        
        mainToggleButton.bottomAnchor.constraint(equalTo: holdToLockLabel.topAnchor, constant: 0).isActive = true
        mainToggleButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        mainToggleButton.contentEdgeInsets = UIEdgeInsets(top: 5.0, left: 15.0, bottom: 5.0, right: 15.0)
        mainToggleButton.layer.cornerRadius = mainToggleButton.bounds.height / 3
        
        facingButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30).isActive = true
        facingButton.centerYAnchor.constraint(equalTo: mainToggleButton.centerYAnchor).isActive = true
        
        facingLabel.topAnchor.constraint(equalTo: facingButton.bottomAnchor, constant: 10).isActive = true
        facingLabel.centerXAnchor.constraint(equalTo: facingButton.centerXAnchor).isActive = true
        
        loopingButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30).isActive = true
        loopingButton.centerYAnchor.constraint(equalTo: mainToggleButton.centerYAnchor).isActive = true
        
        loopingLabel.topAnchor.constraint(equalTo: loopingButton.bottomAnchor, constant: 10).isActive = true
        loopingLabel.centerXAnchor.constraint(equalTo: loopingButton.centerXAnchor).isActive = true
        
        facingLabel.text = viewModel.flashlight.facingSide.name
        loopingButton.alpha = viewModel.flashlight.loop ? 1.0 : 0.5
        loopingLabel.alpha = loopingButton.alpha
        
        //gestures
        longPress = createLongGestureRecognizer()
        lockGesture = createLockGestureRecognizer()
        
        // handle the gesture recogniser when the tool mode is pressed
        modeObserver = viewModel.flashlight.observe(\.observableMode, options: [.new]) { [weak self] flashlight, change in
            guard let newValue = change.newValue else { return }
            guard let self = self else { return }
            let mode = MainMorseViewModel.FlashLightMode.init(rawValue: newValue)
            
            switch mode {
            case .sos:
                self.mainToggleButton.addGestureRecognizer(self.lockGesture)
            case .tools, .messageConversion, .morseConversion:
                self.mainToggleButton.removeGestureRecognizer(self.lockGesture)
            case .none:
                ()
            }
        }
        
        
        // handle the gesture recogniser when the tool mode is pressed
        toolModeObserver = viewModel.flashlight.observe(\.observableToolMode, options: [.new]) { [weak self] flashlight, change in
            guard let newValue = change.newValue else { return }
            guard let self = self else { return }
            let mode = ToolLightMode.init(rawValue: newValue)
            
            switch mode {
            case .hold:
                self.mainToggleButton.addGestureRecognizer(self.longPress)
            case .toggle:
                self.mainToggleButton.removeGestureRecognizer(self.longPress)
            case .none:
                ()
            }
        }
        
        // switch between front and rear text for the labele
        facingSideObserver = viewModel.flashlight.observe(\.observableFacingSide, options: [.new], changeHandler: { [weak self] flashlight, change in
            guard let newValue = change.newValue else { return }
            guard let self = self else { return }
            self.facingLabel.text =  FlashFacingSide.init(rawValue: newValue)?.name
        })
        
        
        // setup ad banner
        if let bool = KeychainWrapper.standard.bool(forKey: IAPProducts.adsId) {
            if !bool {
                bannerView = GADBannerView(adSize: GADAdSizeBanner)
                bannerView.translatesAutoresizingMaskIntoConstraints = false
                bannerView.rootViewController = self
                bannerView.adUnitID = AdDelivery.UnitId
                view.addSubview(bannerView)
                
                bannerView.topAnchor.constraint(equalTo: holdToLockLabel.bottomAnchor, constant: 10).isActive = true
                bannerView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
                bannerView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
                bannerView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
                
                bannerView.load(GADRequest())
            } else {
                holdToLockLabelConstraint.constant = -15
            }
        }
    }
    
    @objc func handleFacingSide() {
        switch viewModel.flashlight.facingSide {
        case .rear:
            viewModel.flashlight.facingSide = .front
        case .front:
            viewModel.flashlight.facingSide = .rear
        }
    }
    
    @objc func showInfo() {
        if let mode = MainMorseViewModel.FlashLightMode.init(rawValue: mainContentCollectionView.indexPathsForVisibleItems.first?.item ?? .zero) {
            viewModel.flashlight.updateMode(mode: mode)
            coordinator.showInfo(mode: viewModel.flashlight.mode)
        }
    }
    
    func scrollToItem(indexPath: IndexPath) {
        if let mode = MainMorseViewModel.FlashLightMode.init(rawValue: indexPath.item) {
            viewModel.flashlight.updateMode(mode: mode)
            mainContentCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        }

    }
    
    // MARK: - Toggle Light whether it's by a short burst SOS, a Message, a switch or hold
    private func toggleSos() {
        if (stateMachine != nil) {
            shutDownStateMachine()
        } else {
            let parser = MorseParser(message: "SOS")
            stateMachine = MorseCodeStateMachineSystem(morseParser: parser, delegate: self)
			
			liveViewController.stateMachine = self.stateMachine

			guard let stateMachine = stateMachine else { return }
            stateMachine.loopState = viewModel.flashlight.loop
            stateMachine.startSystemAtIdle()
			
        }
    }
    
    func toggleMessage() {
        // save message to core data in the recent object
        if (stateMachine != nil) {
            shutDownStateMachine()
        } else {
            if viewModel.messageToBeFlashed != "" {
                let parser = MorseParser(message: viewModel.messageToBeFlashed)
                stateMachine = MorseCodeStateMachineSystem(morseParser: parser, delegate: self)
                guard let stateMachine = stateMachine else { return }
                stateMachine.loopState = viewModel.flashlight.loop
                stateMachine.startSystemAtIdle()
            } else {
                coordinator.showError(error: TextFieldError.empty)
                ImpactFeedbackService.shared.failedFeedback()
            }
        }
        
        guard let moc = viewModel.cds.moc else { return }
        let r = Recent(context: moc)
        // id and date are default values in the function argument array
        r.newRecentObj(value: viewModel.messageToBeFlashed)
        viewModel.cds.saveContext()
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
    
    func createLockGestureRecognizer() -> UILongPressGestureRecognizer {
        let gesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLockGesture))
        gesture.minimumPressDuration = 1.5
        gesture.delaysTouchesBegan = true
        return gesture
    }
    
    @objc func handleLockGesture(gesture: UILongPressGestureRecognizer) {
        if gesture.state == .began {
            print("began")
            print("lock gesture")
            self.handleLock()
        }
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
            
            if (mainToggleButton.isEnabled) {
                switch mode {
                case .sos:
                    print("handle locked mode here with viewmodel variable to keep state")
                    print("\(viewModel.sosLock) sosLock")
                    if !viewModel.sosLock {
                        TelemetryManager.send(TelemetryManager.Signal.sosToggleDidFire.rawValue)
                        ImpactFeedbackService.shared.impactType(feedBackStyle: .heavy)
                        toggleSos()
                    }
                    
                case .messageConversion:
                    TelemetryManager.send(TelemetryManager.Signal.sosMessageConversionDidFire.rawValue)
                    ImpactFeedbackService.shared.impactType(feedBackStyle: .heavy)
                    toggleMessage()
                    viewModel.cds.limitRecentMessages()
                case .tools:
                    TelemetryManager.send(TelemetryManager.Signal.sosToolsDidFire.rawValue)
                    ImpactFeedbackService.shared.impactType(feedBackStyle: .heavy)
                    toggleTools()
                case .morseConversion:
                    TelemetryManager.send(TelemetryManager.Signal.sosMorseConversionDidFire.rawValue)

                    ImpactFeedbackService.shared.impactType(feedBackStyle: .heavy)
                    // message passed via notification center. Look up MESSAGE_TO_TEXT
                }
            }
        }
    }
    
    @objc func handleLooping() {
        viewModel.flashlight.loop = !viewModel.flashlight.loop
        loopingButton.alpha = viewModel.flashlight.loop ? 1.0 : 0.5
        loopingLabel.alpha = loopingButton.alpha
        
        if viewModel.flashlight.loop {
            if viewModel.flashlight.mode == .sos {
                mainToggleButton.addGestureRecognizer(lockGesture)
            }
            lockImage.layer.opacity = 0.4
            holdToLockLabel.layer.opacity = 0.4
        } else {
            lockImage.layer.opacity = 0.0
            holdToLockLabel.layer.opacity = 0.0
            mainToggleButton.removeGestureRecognizer(lockGesture)
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
        stateMachine.loopState = viewModel.flashlight.loop
    }
    
    func willBreak() {
        // Do nothing
    }
    
    // Right before the device will cast the flash
    func willFlash(type: MorseTypeTiming) {
        
        switch type {
			case .breakBetweenLetters:
				if (viewModel.flashFacingSideState == .front) {
					updateFrontScreenFlash(state: false)
				} else {
					viewModel.flashlight.toggleTorch(on: false)
				}
			case .breakBetweenWords, .breakBetweenPartsOfLetter, .none:
                if (viewModel.flashFacingSideState == .front) {
                    updateFrontScreenFlash(state: false)
                } else {
                    viewModel.flashlight.toggleTorch(on: false)
                }
            case .dash, .dot:
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
    
    func didFlash(type: MorseTypeTiming) {
        
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

// Loads only one time per update
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

enum TextFieldError: Error {
    case empty
}
