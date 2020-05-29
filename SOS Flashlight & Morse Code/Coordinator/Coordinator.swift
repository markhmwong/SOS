//
//  Coordinator.swift
//  SOS Flashlight & Morse Code
//
//  Created by Mark Wong on 14/5/20.
//  Copyright © 2020 Mark Wong. All rights reserved.
//

import UIKit

protocol Coordinator: AnyObject {
	var childCoordinators: [Coordinator] { get set }
    var navigationController: UINavigationController { get set }

	func start()
}






