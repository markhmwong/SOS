//
//  FooterView.swift
//  SOS Flashlight & Morse Code
//
//  Created by Mark on 3/11/2023.
//  Copyright © 2023 Mark Wong. All rights reserved.
//

import UIKit

class FooterView: UIView {
	
	lazy var copyright: UILabel = {
		let label = UILabel()
		label.translatesAutoresizingMaskIntoConstraints = false
		label.textAlignment = .center
		label.attributedText = NSMutableAttributedString().tertiaryTitleAttributes(string: "Made In \(Whizbang.madeInMelb)")
		return label
	}()
	
	init() {
		super.init(frame: .zero)
		addSubview(copyright)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func layoutSubviews() {
		super.layoutSubviews()
		copyright.anchorView(top: topAnchor, bottom: nil, leading: leadingAnchor, trailing: trailingAnchor, centerY: nil, centerX: nil, padding: .zero, size: .zero)
	}
}
