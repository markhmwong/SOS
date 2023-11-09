//
//  RecentMessageCell.swift
//  SOS Flashlight & Morse Code
//
//  Created by Mark on 9/11/2023.
//  Copyright © 2023 Mark Wong. All rights reserved.
//

import UIKit

class RecentMessageCell: UICollectionViewCell {
	
	var item: Recent? = nil {
		didSet {
			self.configure()
		}
	}
	
	private lazy var addButton: UIButton = {
		let button = UIButton()
		let image = UIImage(systemName: "plus.circle.fill")
		button.setImage(image, for: .normal)
		button.translatesAutoresizingMaskIntoConstraints = false
		button.addTarget(self, action: #selector(saveMessage), for: .touchDown)
		button.isEnabled = false
		button.alpha = 0
		return button
	}()
	
	override init(frame: CGRect) {
		super.init(frame: frame)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func prepareForReuse() {
		super.prepareForReuse()
		self.item = nil
	}
	
	private func configure() {
		contentView.backgroundColor = .clear
		addSubview(self.addButton)
		
		addButton.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor).isActive = true
		addButton.centerYAnchor.constraint(equalTo: safeAreaLayoutGuide.centerYAnchor).isActive = true
		
	}
	
	@objc func saveMessage() {
		NotificationCenter.default.post(name: .saveMesage, object: item)
	}
}
