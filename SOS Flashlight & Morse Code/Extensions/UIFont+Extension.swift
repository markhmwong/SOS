//
//  UIFont+Extension.swift
//  Pump It Up
//
//  Created by Mark Wong on 8/1/2022.
//

import UIKit

extension UIFont {

    static var largeTitle: UIFont {
        return UIFont.preferredFont(forTextStyle: .largeTitle)
    }

    static var body: UIFont {
        return UIFont.preferredFont(forTextStyle: .body)
    }

    func with(weight: UIFont.Weight) -> UIFont {
        return UIFont.systemFont(ofSize: pointSize, weight: weight)
    }

}
