//
//  UIBarButtonItem.swift
//  Shortlist
//
//  Created by Mark Wong on 17/1/20.
//  Copyright © 2020 Mark Wong. All rights reserved.
//

import UIKit.UIBarButtonItem

extension UIBarButtonItem {
	
	static func menuButton(_ target: Any?, action: Selector, imageName: String, height: CGFloat) -> UIBarButtonItem {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: imageName), for: .normal)
        button.addTarget(target, action: action, for: .touchUpInside)
		button.tintColor = Theme.Font.DefaultColor
		
        let menuBarItem = UIBarButtonItem(customView: button)
        menuBarItem.customView?.translatesAutoresizingMaskIntoConstraints = false
        menuBarItem.customView?.heightAnchor.constraint(equalToConstant: height).isActive = true
        menuBarItem.customView?.widthAnchor.constraint(equalToConstant: height).isActive = true

        return menuBarItem
    }
	
	func settingsButton(target: Any?, action: Selector) -> UIBarButtonItem {
//		let button = UIButton(type: .system)
//		button.setImage(UIImage(systemName: "gearshape.2.fill"), for: .normal)
//		button.addTarget(target, action: action, for: .touchUpInside)
//		button.tintColor = Theme.Font.DefaultColor
        return UIBarButtonItem(image: UIImage(systemName: "gearshape.2.fill"), style: .plain, target: nil, action: nil)
//		return UIBarButtonItem(customView: button)
	}
    
    func tipJarButton(target: Any?, action: Selector) -> UIBarButtonItem {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "gift.fill"), for: .normal)
        button.addTarget(target, action: action, for: .touchUpInside)
        button.tintColor = UIColor.systemOrange
        return UIBarButtonItem(customView: button)
    }
	
}
