//
//  NSMutableAttributedString.swift
//  SOS Flashlight & Morse Code
//
//  Created by Mark Wong on 13/5/20.
//  Copyright © 2020 Mark Wong. All rights reserved.
//

import UIKit.UIFont

extension NSMutableAttributedString {

	func cellTitleProperties() -> [NSAttributedString.Key : Any] {
		return [NSAttributedString.Key.font: UIFont.init(name: Theme.Font.Bold, size: Theme.Font.FontSize.Standard(.h4).value)!, NSAttributedString.Key.foregroundColor: Theme.Font.DefaultColor]
	}
	
	func cellTitlePlaceHolderProperties() -> [NSAttributedString.Key : Any] {
		return [NSAttributedString.Key.font: UIFont.init(name: Theme.Font.Bold, size: Theme.Font.FontSize.Standard(.h4).value)!, NSAttributedString.Key.foregroundColor: Theme.Font.DefaultColor.adjust(by: -70)!]
	}
	
	//MARK: - HEADING
	func primaryTitleAttributes(string: String) -> NSMutableAttributedString {
		return NSMutableAttributedString(string: string, attributes: [NSAttributedString.Key.font: UIFont.init(name: Theme.Font.Bold, size: Theme.Font.FontSize.Standard(.h2).value)!, NSAttributedString.Key.foregroundColor: Theme.Font.DefaultColor])
	}
	
	func secondaryTitleAttributes(string: String) -> NSMutableAttributedString {
		return NSMutableAttributedString(string: string, attributes: [NSAttributedString.Key.font: UIFont.init(name: Theme.Font.Regular, size: Theme.Font.FontSize.Standard(.b2).value)!, NSAttributedString.Key.foregroundColor: Theme.Font.DefaultColor])
	}
	
	func tertiaryTitleAttributes(string: String) -> NSMutableAttributedString {
		return NSMutableAttributedString(string: string, attributes: [NSAttributedString.Key.font: UIFont.init(name: Theme.Font.Regular, size: Theme.Font.FontSize.Standard(.b4).value)!, NSAttributedString.Key.foregroundColor: Theme.Font.DefaultColor])
	}
	
	func primaryTextAttributes(string: String) -> NSMutableAttributedString {
		return NSMutableAttributedString(string: string, attributes: [NSAttributedString.Key.font: UIFont.init(name: Theme.Font.Regular, size: Theme.Font.FontSize.Standard(.b0).value)!, NSAttributedString.Key.foregroundColor: Theme.Font.DefaultColor])
	}
	
	func startButtonAttributes(string: String) -> NSMutableAttributedString {
		return NSMutableAttributedString(string: string, attributes: [NSAttributedString.Key.font: UIFont.init(name: Theme.Font.Bold, size: Theme.Font.FontSize.Standard(.h2).value)!, NSAttributedString.Key.foregroundColor: Theme.Font.DefaultColor])
	}
	
	//MARK: - BUTTON
	func buttonAttributes(string: String) -> NSMutableAttributedString {
		return NSMutableAttributedString(string: string, attributes: [NSAttributedString.Key.font: UIFont.init(name: Theme.Font.Bold, size: Theme.Font.FontSize.Standard(.h3).value)!, NSAttributedString.Key.foregroundColor: Theme.Font.DefaultColor])
	}
	
	//MARK: - CELL
	func cellTitleAttributes(string: String) -> NSMutableAttributedString {
		return NSMutableAttributedString(string: string, attributes: cellTitleProperties())
	}
	
	func cellTitlePlaceholderAttributes(string: String) -> NSMutableAttributedString {
		return NSMutableAttributedString(string: string, attributes: cellTitlePlaceHolderProperties())
	}
	

	
	//MARK: - TIMER
	func timeAttributes(string: String) -> NSMutableAttributedString {
		return NSMutableAttributedString(string: string, attributes: [NSAttributedString.Key.font: UIFont.init(name: Theme.Font.Bold, size: Theme.Font.FontSize.Standard(.h0).value)!, NSAttributedString.Key.foregroundColor: Theme.Font.DefaultColor])
	}
	
	func setAttributes(string: String) -> NSMutableAttributedString {
		return NSMutableAttributedString(string: string, attributes: [NSAttributedString.Key.font: UIFont.init(name: Theme.Font.Bold, size: Theme.Font.FontSize.Standard(.h2).value)!, NSAttributedString.Key.foregroundColor: Theme.Font.DefaultColor])
	}
}
