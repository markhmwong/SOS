//
//  SceneDelegate.swift
//  SOS Flashlight & Morse Code
//
//  Created by Mark Wong on 6/5/20.
//  Copyright © 2020 Mark Wong. All rights reserved.
//

import UIKit
import TelemetryClient
import GoogleMobileAds

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

	var window: UIWindow?

    var cds: CoreDataStack = CoreDataStack.shared
    
	func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
		// Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
		// If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
		// This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
		guard let windowScene = (scene as? UIWindowScene) else { return }
		
//		FirebaseApp.configure()
		IAPProducts.tipStore.addStoreObserver()

		window = UIWindow()
		window?.makeKeyAndVisible()
		
		let nav = UINavigationController()
		let coordinator = MainCoordinator(navigationController: nav)
		coordinator.start(cds)
		window?.rootViewController = nav
		window?.windowScene = windowScene
        
        GADMobileAds.sharedInstance().start(completionHandler: nil)
        let configuration = TelemetryManagerConfiguration(appID: Whizbang.telemetryDeckAppId)
        TelemetryManager.initialize(with: configuration)
	}

	func sceneDidDisconnect(_ scene: UIScene) {
		// Called as the scene is being released by the system.
		// This occurs shortly after the scene enters the background, or when its session is discarded.
		// Release any resources associated with this scene that can be re-created the next time the scene connects.
		// The scene may re-connect later, as its session was not neccessarily discarded (see `application:didDiscardSceneSessions` instead).
        TelemetryManager.send(TelemetryManager.Signal.appDidDisconnect.rawValue)

	}

	func sceneDidBecomeActive(_ scene: UIScene) {
        let ads = AdService()
        ads.requestPermission()
        TelemetryManager.send(TelemetryManager.Signal.appDidBecomeActive.rawValue)
	}

	func sceneWillResignActive(_ scene: UIScene) {
        TelemetryManager.send(TelemetryManager.Signal.appWillResignActive.rawValue)

	}

	func sceneWillEnterForeground(_ scene: UIScene) {
        TelemetryManager.send(TelemetryManager.Signal.appDidEnterForeground.rawValue)

		// Called as the scene transitions from the background to the foreground.
		// Use this method to undo the changes made on entering the background.
	}

	func sceneDidEnterBackground(_ scene: UIScene) {
        TelemetryManager.send(TelemetryManager.Signal.appDidEnterBackground.rawValue)

		// Called as the scene transitions from the foreground to the background.
		// Use this method to save data, release shared resources, and store enough scene-specific state information
		// to restore the scene back to its current state.

		// Save changes in the application's managed object context when the application transitions to the background.
		(UIApplication.shared.delegate as? AppDelegate)?.saveContext()
	}


}

