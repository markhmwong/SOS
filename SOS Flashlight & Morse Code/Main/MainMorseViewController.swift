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
    
    var viewModel: MainMorseViewModel
  
    var mainContentCollectionView: UICollectionView! = nil
    
    var menuBar: MenuBar! = nil
    	
    private var coordinator: MainCoordinator

    private var stateMachine: MorseCodeStateMachineSystem? = nil

    private var  bannerView: GADBannerView!
	
	var flashlightObserver: NSKeyValueObservation?
    
    lazy var mainToggleButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(handleToggle), for: .touchDown)
        let config = UIImage.SymbolConfiguration(pointSize: UIScreen.main.bounds.height / 27, weight: .bold, scale: .large)
        let image = UIImage(systemName: "togglepower", withConfiguration: config)
        button.setImage(image, for: .normal)
        button.tintColor = .systemOrange
        button.backgroundColor = .clear
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var holdToLockLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Hold to lock"
        label.layer.opacity = 1.0
        label.textColor = UIColor.defaultText
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
	
	lazy var holdButton: UIButton = {
		let button = UIButton()
		button.addTarget(self, action: #selector(handleHold), for: .touchDown)
		let config = UIImage.SymbolConfiguration(pointSize: UIScreen.main.bounds.height / 60, weight: .bold, scale: .large)
		let image = UIImage(systemName: "pause.fill", withConfiguration: config)
		button.setImage(image, for: .normal)
		button.tintColor = .defaultText
		button.backgroundColor = .clear
		button.translatesAutoresizingMaskIntoConstraints = false
		button.alpha = 0
		return button
	}()
	
	lazy var holdLabel: UILabel = {
		let label = UILabel()
		label.translatesAutoresizingMaskIntoConstraints = false
		label.text = "Hold" // front or rear
		label.alpha = 0
		label.font = UIFont.preferredFont(forTextStyle: .caption1)
		label.textColor = UIColor.defaultText
		return label
	}()
    
    lazy var conversionInfoLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Please delimit each english letter with a space when writing morse code i.e. ... --- ..." // front or rear
        label.alpha = 0
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = UIFont.preferredFont(forTextStyle: .caption1)
        label.textColor = UIColor.defaultText
        return label
    }()
	
	lazy var messageField: UITextView = {
		let textField = UITextView()
		textField.tintColor = UIColor.defaultText
		textField.font = UIFont.preferredFont(forTextStyle: .body)
		textField.layer.cornerRadius = 0
		textField.translatesAutoresizingMaskIntoConstraints = false
        textField.keyboardType = .alphabet
        textField.returnKeyType = .default
		textField.enablesReturnKeyAutomatically = false
		textField.text = "Type a message"
		textField.delegate = self
		textField.autocapitalizationType = .none
		textField.autocorrectionType = .no
		textField.isEditable = true
		textField.textAlignment = .left
		textField.isScrollEnabled = false
		textField.layer.cornerRadius = 12.0
		textField.layer.masksToBounds = true
		textField.backgroundColor = UIColor.defaultText.inverted
		return textField
	}()
    
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
	
	private var liveTextViewController: LiveTextViewController
    
	private var frontFacingLightViewController: FrontFacingLcdViewController
	
	private var lightIndicatorViewController: LightIndicatorViewController
	
    var longPress: UILongPressGestureRecognizer! =  nil
    
    var lockGesture: UILongPressGestureRecognizer! =  nil

    private var toolModeObserver: NSKeyValueObservation? = nil

    private var modeObserver: NSKeyValueObservation? = nil

    private var facingSideObserver: NSKeyValueObservation? = nil

	private weak var bottomConstraint: NSLayoutConstraint!
	
	var recentButton: UIBarButtonItem! = nil
	
    init(viewModel: MainMorseViewModel, coordinator: MainCoordinator) {
        self.coordinator = coordinator
        self.viewModel = viewModel
		self.liveTextViewController = LiveTextViewController(viewModel: viewModel)
		self.frontFacingLightViewController = FrontFacingLcdViewController(nibName: nil, bundle: nil)
		self.lightIndicatorViewController = LightIndicatorViewController(nibName: nil, bundle: nil)
		super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
	
	override func viewDidLoad() {
		super.viewDidLoad()
		self.setupUI()
		
		mainContentCollectionView.isDirectionalLockEnabled = false
		mainContentCollectionView.isScrollEnabled = false
		mainContentCollectionView.showsVerticalScrollIndicator = false
		mainContentCollectionView.showsHorizontalScrollIndicator = false
		
		NotificationCenter.default.addObserver(self, selector: #selector(handleSavedMessages), name: .showSavedMessages, object: nil)
		NotificationCenter.default.addObserver(self, selector: #selector(handleRecentMessages), name: .showRecentMessages, object: nil)
		NotificationCenter.default.addObserver(self, selector: #selector(updateMessageField), name: Notification.Name(NotificationCenter.NCKeys.MESSAGE_TO_FLASH), object: nil)
		
		
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
		observers()
	}
	
	/* MARK: - Button selector methods */
    
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
                self.lockImage.layer.opacity = 1.0
                self.facingLabel.layer.opacity = 1.0
        } else {
                self.lockImage.layer.opacity = 0.4
                self.facingLabel.layer.opacity = 0.4
        }

        mainContentCollectionView.isScrollEnabled = loopingButton.isEnabled
        mainContentCollectionView.isUserInteractionEnabled = loopingButton.isEnabled
    }
	
	@objc func handleFacingSide() {
		switch viewModel.flashlight.facingSide {
			case .rear:
				viewModel.flashlight.facingSide = .front
			case .front:
				viewModel.flashlight.facingSide = .rear
		}
	}
	
	@objc func handleToggle() {
		if let mode = MainMorseViewModel.SOSMode.init(rawValue: mainContentCollectionView.indexPathsForVisibleItems.first?.item ?? .zero) {
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
						
					case .encodeMorse:
						TelemetryManager.send(TelemetryManager.Signal.sosMessageConversionDidFire.rawValue)
						ImpactFeedbackService.shared.impactType(feedBackStyle: .heavy)
						toggleMessage()
						viewModel.cds.cleanupRecentMessages()
					case .tools:
						TelemetryManager.send(TelemetryManager.Signal.sosToolsDidFire.rawValue)
						ImpactFeedbackService.shared.impactType(feedBackStyle: .heavy)
						toggleTools()
					case .decodeMorse:
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
	
	@objc func handleHold() {
		// when switch between modes, reset the light
		viewModel.flashlight.toggleTorch(on: false)
		
		// switch between hold mode and toggle
		switch viewModel.flashlight.toolMode {
			case .hold:
				viewModel.flashlight.updateToolMode(mode: .toggle)
				UIView.animate(withDuration: 0.1) {
					self.holdButton.alpha = 1.0
				}
			case .toggle:
				viewModel.flashlight.updateToolMode(mode: .hold)
				UIView.animate(withDuration: 0.1) {
					self.holdButton.alpha = 0.4
				}
				
		}
	}
    

	
	private func observers() {
		flashlightObserver = viewModel.flashlight.observe(\.lightSwitch, options:[.new]) { [self] flashlight, change in
			guard let light = change.newValue else { return }
			if flashlight.flashlightMode() == .sos {
				
				// front facing
				if flashlight.facingSide == .rear {
					// update circle
					
//					light ? self.updateFrontIndicator(UIColor.Indicator.flashing.cgColor) : self.updateFrontIndicator(UIColor.Indicator.dim.cgColor)
				} else {
					if light {
						UIView.animate(withDuration: 0.15, delay: 0.0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: [.curveEaseInOut]) {
							self.frontFacingLightViewController.view.backgroundColor = UIColor.mainBackground.inverted
						}
					} else {
						UIView.animate(withDuration: 0.15, delay: 0.0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: [.curveEaseInOut]) {
							self.frontFacingLightViewController.view.backgroundColor = UIColor.mainBackground
						}
					}
				}
				
			}
		}
	}
	
	/* MARK: - Navigation Related */
    
    @objc func showSettings() {
        coordinator.showSettings()
    }
    
    @objc func showTipJar() {
        coordinator.showTipJar()
    }
	
	@objc func showInfo() {
		if let mode = MainMorseViewModel.SOSMode.init(rawValue: mainContentCollectionView.indexPathsForVisibleItems.first?.item ?? .zero) {
			viewModel.flashlight.updateMode(mode: mode)
			coordinator.showInfo(mode: viewModel.flashlight.mode)
		}
	}

	private func showMessageField(alpha: CGFloat) {
		UIView.animate(withDuration: 0.15) {
			self.messageField.alpha = alpha
		}
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
		addChild(frontFacingLightViewController)
		addChild(liveTextViewController)
		addChild(lightIndicatorViewController)
		view.addSubview(frontFacingLightViewController.view)
		view.addSubview(liveTextViewController.view)
		view.addSubview(lightIndicatorViewController.view)

		view.addSubview(menuBar)
		view.addSubview(mainToggleButton)
		view.addSubview(facingButton)
		view.addSubview(facingLabel)
		view.addSubview(loopingButton)
		view.addSubview(holdButton)
		view.addSubview(loopingLabel)
		view.addSubview(lockImage)
		view.addSubview(holdToLockLabel)
        
        view.addSubview(conversionInfoLabel)
		view.addSubview(messageField)
		view.addSubview(holdLabel)
		
		// message to signal methods
		messageToolbar()
		flashlightFacade()
		startObservingKeyboardChanges()
		
        
        conversionInfoLabel.bottomAnchor.constraint(equalTo: messageField.topAnchor, constant: -5).isActive = true
        conversionInfoLabel.centerXAnchor.constraint(equalTo: messageField.centerXAnchor).isActive = true
        conversionInfoLabel.leadingAnchor.constraint(equalTo: messageField.leadingAnchor, constant:20).isActive = true
        conversionInfoLabel.trailingAnchor.constraint(equalTo: messageField.trailingAnchor, constant:-20).isActive = true

		messageField.leadingAnchor.constraint(equalTo: menuBar.leadingAnchor, constant: 20).isActive = true
		messageField.trailingAnchor.constraint(equalTo: menuBar.trailingAnchor, constant: -20).isActive = true
		bottomConstraint = self.messageField.bottomAnchor.constraint(equalTo: menuBar.topAnchor)
		bottomConstraint.isActive = true
		
		
		liveTextViewController.view.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
		liveTextViewController.view.bottomAnchor.constraint(equalTo: menuBar.topAnchor).isActive = true
		liveTextViewController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
		liveTextViewController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true

		holdButton.leadingAnchor.constraint(equalTo: loopingButton.trailingAnchor, constant: 30).isActive = true
		holdButton.centerYAnchor.constraint(equalTo: loopingButton.centerYAnchor).isActive = true
		
		holdLabel.topAnchor.constraint(equalTo: holdButton.bottomAnchor, constant: 10).isActive = true
		holdLabel.centerXAnchor.constraint(equalTo: holdButton.centerXAnchor).isActive = true
		
//        let holdToLockLabelConstraint = holdToLockLabel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0)
//        holdToLockLabelConstraint.constant = -70
//        holdToLockLabelConstraint.isActive = true
//
//        holdToLockLabel.centerXAnchor.constraint(equalTo: mainToggleButton.centerXAnchor).isActive = true
        
        // setup ad banner
        setupAdBanner()
        
        lockImage.bottomAnchor.constraint(equalTo: mainToggleButton.topAnchor, constant: 0).isActive = true
        lockImage.centerXAnchor.constraint(equalTo: mainToggleButton.centerXAnchor).isActive = true
        
        menuBar.bottomAnchor.constraint(equalTo: self.mainToggleButton.topAnchor, constant: -10).isActive = true
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
        
		
		if viewModel.flashlight.mode != .encodeMorse {
			messageField.alpha = 0.0
			messageField.isEditable = false
		}
		
        //gestures
        longPress = createLongGestureRecognizer()
        lockGesture = createLockGestureRecognizer()
        
        // handle the gesture recogniser when the tool mode is pressed to lock the signal button
        modeObserver = viewModel.flashlight.observe(\.observableMode, options: [.new]) { [weak self] flashlight, change in
            guard let newValue = change.newValue else { return }
            guard let self = self else { return }
            let mode = MainMorseViewModel.SOSMode.init(rawValue: newValue)
            
            switch mode {
            case .sos:
                self.mainToggleButton.addGestureRecognizer(self.lockGesture)
            case .tools, .encodeMorse, .decodeMorse:
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
    }
    
    func setupAdBanner() {
        // chain to the bottom of the screen and adjust constant as required
        let holdToLockLabelConstraint = holdToLockLabel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0)
        holdToLockLabelConstraint.constant = 0
        holdToLockLabelConstraint.isActive = true
        holdToLockLabel.centerXAnchor.constraint(equalTo: mainToggleButton.centerXAnchor).isActive = true

        if SubscriptionService.shared.getCustomerProStatusFromKeyChain() {
            print("MainMorseViewController: pro status")
            holdToLockLabelConstraint.constant = 0
        } else {
            holdToLockLabelConstraint.constant = -70

            print("MainMorseViewController: is not pro status")
           
            bannerView = GADBannerView(adSize: GADAdSizeBanner)
            bannerView.translatesAutoresizingMaskIntoConstraints = false
            bannerView.rootViewController = self
            bannerView.adUnitID = AdDelivery.UnitId
            view.addSubview(bannerView)
            
            bannerView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
            bannerView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
            bannerView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
            
            bannerView.load(GADRequest())
        }
    }
	
	/* Observing keyboard */
	func startObservingKeyboardChanges() {
		
		// NotificationCenter observers
		NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: nil) { [weak self] notification in
			self?.keyboardWillShow(notification)
		}
		
		// Deal with rotations
//		NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillChangeFrameNotification, object: nil, queue: nil) { [weak self] notification in
//			self?.keyboardWillShow(notification)
//		}
		
		// Deal with keyboard change (emoji, numerical, etc.)
		NotificationCenter.default.addObserver(forName: UITextInputMode.currentInputModeDidChangeNotification, object: nil, queue: nil) { [weak self] notification in
			self?.keyboardWillShow(notification)
		}
		
		NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: nil) { [weak self] notification in
			self?.keyboardWillHide(notification)
		}
	}
	
	@objc func updateMessageField(_ sender: Notification) {
		guard let message = sender.userInfo?[NotificationCenter.NCKeys.MESSAGE_TO_FLASH] as? String else { return }

		self.messageField.text = message
	}

	// change tool mode between sos, message, conversion, tools
	func scrollToMode(_ mode: MainMorseViewModel.SOSMode) {
        messageField.text = ""
        
		viewModel.flashlight.updateMode(mode: mode)
		
		shutDownStateMachine()
		
		// message field configurations
		switch mode {
			case .encodeMorse:
				liveTextViewController.updateTextFields(message: "Send a signal")
				lightIndicatorViewController.view.alpha = 0
				showMessageField(alpha: 1.0)
				messageField.isEditable = true
				recentButton.isEnabled = true
				UIView.animate(withDuration: 0.1) {
					self.liveTextViewController.view.alpha = 1.0
					self.holdButton.alpha = 0.0
					self.holdLabel.alpha = 0.0
                    self.conversionInfoLabel.alpha = 0.0
					self.loopingButton.alpha = 1.0
					self.loopingLabel.alpha = 1.0
				}
				holdButton.isEnabled = false
				loopingButton.isEnabled = true
			case .sos:
				lightIndicatorViewController.view.alpha = 0
				liveTextViewController.updateTextFields(message: "SOS")
				showMessageField(alpha: 0)
				messageField.isEditable = false
				UIView.animate(withDuration: 0.1) {
					self.liveTextViewController.view.alpha = 1.0
					self.holdButton.alpha = 0.0
					self.holdLabel.alpha = 0.0
                    self.conversionInfoLabel.alpha = 0.0
					self.loopingButton.alpha = 1.0
					self.loopingLabel.alpha = 1.0
				}
				holdButton.isEnabled = false
				loopingButton.isEnabled = true
			case .decodeMorse:
				lightIndicatorViewController.view.alpha = 0
				liveTextViewController.updateTextFields(message: "Convert a message")
				showMessageField(alpha: 1.0)
				messageField.isEditable = true
				recentButton.isEnabled = false
				UIView.animate(withDuration: 0.1) {
					self.liveTextViewController.view.alpha = 1.0
					self.holdButton.alpha = 0.0
					self.holdLabel.alpha = 0.0
                    self.conversionInfoLabel.alpha = 0.8
					self.loopingButton.alpha = 1.0
					self.loopingLabel.alpha = 1.0
				}
				holdButton.isEnabled = false
				loopingButton.isEnabled = true
				
			case .tools:
				showMessageField(alpha: 0)
				messageField.isEditable = false
				UIView.animate(withDuration: 0.1) {
					self.liveTextViewController.view.alpha = 0
					self.holdButton.alpha = 1.0
					self.holdLabel.alpha = 1.0
                    self.conversionInfoLabel.alpha = 0.0
					self.loopingButton.alpha = 0.0
					self.loopingLabel.alpha = 0.0
					self.lightIndicatorViewController.view.alpha = 1.0
				}
				holdButton.isEnabled = true
				loopingButton.isEnabled = false
				
		}
    }
	

    
    // MARK: - Toggle Light whether it's by a short burst SOS, a Message, a switch or hold
    private func toggleSos() {
        if (stateMachine != nil) {
			// shut down the state machine in the scenario the user switches between modes
            shutDownStateMachine()
        } else {
            let parser = MorseParser(message: "SOS")
            stateMachine = MorseCodeStateMachineSystem(morseParser: parser, delegate: self)
			
			liveTextViewController.stateMachine = self.stateMachine

			guard let stateMachine = stateMachine else { return }
            stateMachine.loopState = viewModel.flashlight.loop
            stateMachine.startSystemAtIdle()
			
        }
    }
    
    func toggleMessage() {
        // save message to core data in the recent object
        if (stateMachine != nil) {
			// clear live text
			liveTextViewController.tidyUpHighlightViews()
			// reset state machine
            shutDownStateMachine()
        } else {
            if viewModel.messageToBeSignalled != "" {
                let parser = MorseParser(message: viewModel.messageToBeSignalled)
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
        r.newRecentObj(value: viewModel.messageToBeSignalled)
        viewModel.cds.saveContext()
    }
    
    // binary state
    func toggleTools() {
        switch viewModel.flashlight.toolMode {
            case .toggle:
				switch viewModel.flashlight.facingSide {
					case .front:
						viewModel.flashlight.lightSwitch = !viewModel.flashlight.lightSwitch
						viewModel.updateFrontScreenFlash(state: !viewModel.flashlight.lightSwitch, vc: self.frontFacingLightViewController)
					case .rear:
						viewModel.updateIndicator(on: !viewModel.flashlight.lightSwitch, vc: lightIndicatorViewController)
						viewModel.flashlight.toggleTorch(on: !viewModel.flashlight.lightSwitch)
				}
            case .hold:
				()
        }
    }

//     MARK: - Touch Gestures
	func createLockGestureRecognizer() -> UILongPressGestureRecognizer {
		let gesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLockGesture))
		gesture.minimumPressDuration = 1.5
		gesture.delaysTouchesBegan = true
		return gesture
	}
	
	@objc func handleLockGesture(gesture: UILongPressGestureRecognizer) {
		if gesture.state == .began {
			handleLock()
			ImpactFeedbackService.shared.impactType(feedBackStyle: .heavy)
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
    

    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        shutDownStateMachine()
    }
	
	deinit {
		NotificationCenter.default.removeObserver(self)
	}
}

// MARK: - Delegate methods for state machine
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
				if (viewModel.flashlight.facingSide == .front) {
					viewModel.updateFrontScreenFlash(state: false, vc: frontFacingLightViewController)
				} else {
					viewModel.flashlight.toggleTorch(on: false)
				}
			case .breakBetweenWords, .breakBetweenPartsOfLetter, .none:
                if (viewModel.flashlight.facingSide == .front) {
					viewModel.updateFrontScreenFlash(state: false, vc: frontFacingLightViewController)
                } else {
                    viewModel.flashlight.toggleTorch(on: false)
                }
            case .dash, .dot:
                if (viewModel.flashlight.facingSide == .front) {
					viewModel.updateFrontScreenFlash(state: true, vc: frontFacingLightViewController)
                } else {
                    viewModel.flashlight.toggleTorch(on: true)
                }
        }
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



extension MainMorseViewController {
	/* Keyboard stuff */
	
	func keyboardWillShow(_ notification: Notification) {
		
		guard let value = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
		let keyboardOriginY = value.cgRectValue.origin.y
		let padding: CGFloat = 10
		let adjustment = -(self.messageField.frame.origin.y + self.messageField.frame.height) + keyboardOriginY
		// Here you could have more complex rules, like checking if the textField currently selected is actually covered by the keyboard, but that's out of this scope.
		self.bottomConstraint.constant = adjustment - padding
		print("\(self.messageField.frame.origin.y)")
		UIView.animate(withDuration: 0.1, animations: { () -> Void in
			self.view.layoutIfNeeded()
		})
	}
	
	
	func keyboardWillHide(_ notification: Notification) {
		self.bottomConstraint.constant = 0
		
		UIView.animate(withDuration: 0.1, animations: { () -> Void in
			self.view.layoutIfNeeded()
		})
	}
}



enum TextFieldError: Error {
    case empty
}
