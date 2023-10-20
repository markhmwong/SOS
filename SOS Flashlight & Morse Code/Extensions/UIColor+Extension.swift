//
//  Extension+UIColor.swift
//  EveryTime
//
//  Created by Mark Wong on 30/5/19.
//  Copyright © 2019 Mark Wong. All rights reserved.
//

import UIKit

extension UIColor {
    
    var inverted: UIColor {
        var a: CGFloat = 0.0, r: CGFloat = 0.0, g: CGFloat = 0.0, b: CGFloat = 0.0
        return getRed(&r, green: &g, blue: &b, alpha: &a) ? UIColor(red: 1.0-r, green: 1.0-g, blue: 1.0-b, alpha: a) : .black
    }
    
    func lighter(by percentage: CGFloat = 30.0) -> UIColor? {
        return self.adjust(by: abs(percentage))
    }
    
    func darker(by percentage: CGFloat = 30.0) -> UIColor? {
        return self.adjust(by: -1 * abs(percentage) )
    }
    
    func adjust(by percentage: CGFloat = 30.0) -> UIColor? {
        var red: CGFloat = 0, green: CGFloat = 0, blue: CGFloat = 0, alpha: CGFloat = 0
        if self.getRed(&red, green: &green, blue: &blue, alpha: &alpha) {
            return UIColor(red: min(red + percentage/100, 1.0),
                           green: min(green + percentage/100, 1.0),
                           blue: min(blue + percentage/100, 1.0),
                           alpha: alpha)
        } else {
            return nil
        }
    }
    
    static let defaultBlack: UIColor = UIColor.init(red: 20/255, green: 20/255, blue: 20/255, alpha: 1.0)
    
    static let defaultWhite: UIColor = UIColor.init(red: 240/255, green: 240/255, blue: 240/255, alpha: 1.0)
    
    static let defaultText: UIColor = {
        if #available(iOS 13.0, *) {
            return UIColor.init { (UITraitCollection) -> UIColor in
                switch (UITraitCollection.userInterfaceStyle) {
                    case .dark, .unspecified:
                    return UIColor.defaultWhite
                    case .light:
                        return UIColor.defaultBlack
                    @unknown default:
                        return .red
                }
            }
        } else {
            return UIColor.defaultBlack
        }
    }()
    
    // background color for the main view
    static let mainBackground: UIColor = {
        if #available(iOS 13.0, *) {
            return UIColor.init { (UITraitCollection) -> UIColor in
                switch (UITraitCollection.userInterfaceStyle) {
                    case .dark, .unspecified:
                        return UIColor.white.adjust(by: -90)!
                    case .light:
                        return .white
                    @unknown default:
                        return UIColor.white.adjust(by: -90)!
                }
            }
        } else {
            return .red
        }
    }()
    
    struct Dark {
        static var primary: UIColor = UIColor.black.adjust(by: 5)!
        //        static var secondary: UIColor = UIColor.black.adjust(by: 10)!
        static let secondary: UIColor = {
            if #available(iOS 13.0, *) {
                return UIColor.init { (UITraitCollection) -> UIColor in
                    switch (UITraitCollection.userInterfaceStyle) {
                    case .dark, .unspecified:
                        return UIColor.white.adjust(by: -90)!
                    case .light:
                        return UIColor.black.adjust(by: 10)!
                    @unknown default:
                        return UIColor.white.adjust(by: -90)!
                    }
                }
            } else {
                return .red
            }
        }()
        static let tertiary: UIColor = {
            if #available(iOS 13.0, *) {
                return UIColor.init { (UITraitCollection) -> UIColor in
                    switch (UITraitCollection.userInterfaceStyle) {
                    case .dark, .unspecified:
                        return UIColor.white.adjust(by: -90)!
                    case .light:
                        return UIColor.black.adjust(by: 30)!
                    @unknown default:
                        return UIColor.white.adjust(by: -90)!
                    }
                }
            } else {
                return .red
            }
        }()
    }
    
    struct Indicator {
        static var flashing: UIColor = UIColor.white
        static var dim: UIColor = UIColor.white.adjust(by: -60)!
    }
}
