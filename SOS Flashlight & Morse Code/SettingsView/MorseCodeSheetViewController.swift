//
//  MorseCodeSheetViewController.swift
//  SOS Flashlight & Morse Code
//
//  Created by Mark Wong on 21/5/20.
//  Copyright © 2020 Mark Wong. All rights reserved.
//

import UIKit

protocol BaseViewControllerProtocol {
	associatedtype VM
	associatedtype C
}

class BaseViewController<VM, C>: UIViewController, BaseViewControllerProtocol {
	
	internal var viewModel: VM
	
	internal var coordinator: C
	
	init(viewModel: VM, coordinator: C) {
		self.viewModel = viewModel
		self.coordinator = coordinator
		super.init(nibName: nil, bundle: nil)
		self.view.backgroundColor = Theme.mainBackground

	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
}

class MorseCodeSheetViewController: BaseViewController<MorseCodeSheetViewModel, MorseCodeSheetCoordinator> {
	
	lazy var content: UILabel = {
		let label = UILabel()
		label.numberOfLines = 0
		label.translatesAutoresizingMaskIntoConstraints = false
		label.attributedText = NSMutableAttributedString().secondaryTitleAttributes(string: "The list of characters available range from small and upper case a-z and the numbers 0-9. You'll find that small and upper case letters are in fact the same but I've written them out for clarity.")
		return label
	}()
	
	lazy var morseCodeSheet: UITextView = {
		let textView = UITextView()
		textView.isEditable = false
		textView.isSelectable = true
		textView.textColor = Theme.Font.DefaultColor
		textView.backgroundColor = .clear
		textView.translatesAutoresizingMaskIntoConstraints = false
		return textView
	}()
	
	override init(viewModel: MorseCodeSheetViewModel, coordinator: MorseCodeSheetCoordinator) {
		super.init(viewModel: viewModel, coordinator: coordinator)
	}
	
	required init?(coder: NSCoder) {
		super.init(coder: coder)
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		var morseSheet = ""
		
		let sorted = viewModel.internationalMorseCode.sorted { (arg0, arg1) -> Bool in
			return arg0.key < arg1.key
		}
		
		for code in sorted {
			morseSheet = morseSheet + "\(code.key) - \(code.value)\n"
		}
		
		morseCodeSheet.attributedText = NSMutableAttributedString().primaryTextAttributes(string: morseSheet)
		// Alignment must be set after setting text for a UITextView
		morseCodeSheet.textAlignment = .center

		view.addSubview(morseCodeSheet)
		view.addSubview(content)
		content.anchorView(top: view.safeAreaLayoutGuide.topAnchor, bottom: nil, leading: view.leadingAnchor, trailing: view.trailingAnchor, centerY: nil, centerX: nil, padding: UIEdgeInsets(top: 10, left: 20, bottom: 0, right: -20), size: .zero)
		morseCodeSheet.anchorView(top: content.bottomAnchor, bottom: view.bottomAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor, centerY: nil, centerX: nil, padding: UIEdgeInsets(top: 10.0, left: 0.0, bottom: 0.0, right: 0.0), size: .zero)
		
	}
}

class MorseCodeSheetViewModel: NSObject {
	
	let internationalMorseCode: [Letter: MorseCode] = [
		"a" : ".-",
		"b" : "-...",
		"c" : "-.-.",
		"d" : "-..",
		"e" : ".",
		"f" : "..-.",
		"g" : "--.",
		"h" : "....",
		"i" : "..",
		"j" : ".---",
		"k" : "-.-",
		"l" : ".-..",
		"m" : "--",
		"n" : "-.",
		"o" : "---",
		"p" : ".--.",
		"q" : "--.-",
		"r" : ".-.",
		"s" : "...",
		"t" : "-",
		"u" : "..-",
		"v" : "...-",
		"w" : ".--",
		"x" : "-..-",
		"y" : "-.--",
		"z" : "--..",
		"A" : ".-",
		"B" : "-...",
		"C" : "-.-.",
		"D" : "-..",
		"E" : ".",
		"F" : "..-.",
		"G" : "--.",
		"H" : "....",
		"I" : "..",
		"J" : ".---",
		"K" : "-.-",
		"L" : ".-..",
		"M" : "--",
		"N" : "-.",
		"O" : "---",
		"P" : ".--.",
		"Q" : "--.-",
		"R" : ".-.",
		"S" : "...",
		"T" : "-",
		"U" : "..-",
		"V" : "...-",
		"W" : ".--",
		"X" : "-..-",
		"Y" : "-.--",
		"Z" : "--..",
		"1" : ".----",
		"2" : "..---",
		"3" : "...--",
		"4" : "....-",
		"5" : ".....",
		"6" : "-....",
		"7" : "--...",
		"8" : "---..",
		"9" : "----.",
		"0" : "-----",
	]
	
	override init() {
		
	}
	
}

class MorseCodeSheetCoordinator: Coordinator {
	var childCoordinators: [Coordinator] = []
	
	var navigationController: UINavigationController
	
	init(navigationController: UINavigationController) {
		self.navigationController = navigationController
	}
	
	func start() {
		let vc = MorseCodeSheetViewController(viewModel: MorseCodeSheetViewModel(), coordinator: self)
		navigationController.pushViewController(vc, animated: true)
	}
	
	
}

