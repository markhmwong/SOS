//
//  UIColor+Theme.swift
//  ReadyPlayer
//
//  Created by Mark Wong on 29/6/19.
//  Copyright © 2019 Mark Wong. All rights reserved.
//

import UIKit

struct Theme {
    
	//MARK: - Background colors
	struct MessageBox {
		static var primary: UIColor = UIColor.black.adjust(by: 10)!
		static var secondary: UIColor = UIColor.black.adjust(by: 5)!
		static var tertiary: UIColor = UIColor.black.adjust(by: 20)!
	}
	
	struct Indicator {
		static var flashing: UIColor = UIColor.white
		static var dim: UIColor = UIColor.white.adjust(by: -60)!
	}
	
	struct FrontScreenFlash {
		static var flashing: UIColor = UIColor.white
		static var dim: UIColor = UIColor.white.adjust(by: -90)!
	}
	
	struct Dark {
		static var primary: UIColor = UIColor.black.adjust(by: 5)!
		static var secondary: UIColor = UIColor.black.adjust(by: 10)!
		static var tertiary: UIColor = UIColor.black.adjust(by: 30)!
	}
	
	struct Light {
		static var primary: UIColor = UIColor.white
		static var secondary: UIColor = UIColor.white.adjust(by: -10)!
		static var tertiary: UIColor = UIColor.white.adjust(by: -30)!
	}
	
    struct Font {
        static var Regular: String = "HelveticaNeue"
        static var Bold: String = "Avenir-Black"
		static var TitleRegular: String = "Georgia"
		static var TitleBold: String = "Georgia-Bold"
		
		static let Warning: UIColor = {
			if #available(iOS 13.0, *) {
				return UIColor.init { (UITraitCollection) -> UIColor in
					switch (UITraitCollection.userInterfaceStyle) {
						case .dark, .unspecified:
							return .red
						case .light:
							return .red
						@unknown default:
							return .red
					}
				}
			} else {
				return .red
			}
		}()
		
		static let Placeholder: UIColor = {
			if #available(iOS 13.0, *) {
				return UIColor.init { (UITraitCollection) -> UIColor in
					switch (UITraitCollection.userInterfaceStyle) {
						case .dark, .unspecified:
							return UIColor.white.adjust(by: 40.0)!
						case .light:
							return UIColor.black.adjust(by: 40.0)!
						@unknown default:
							return UIColor.white.adjust(by: 40.0)!
					}
				}
			} else {
				return UIColor.white.adjust(by: 40.0)!
			}
		}()
		
		static let DefaultColor: UIColor = {
			if #available(iOS 13.0, *) {
				return UIColor.init { (UITraitCollection) -> UIColor in
					switch (UITraitCollection.userInterfaceStyle) {
						case .dark, .unspecified:
							return .white
						case .light:
							return .white
						@unknown default:
							return .white
					}
				}
			} else {
				return .white
			}
		}()
		
        enum StandardSizes: CGFloat {
            //title sizes
            case h0 = 65.0
            case h1 = 48.0
            case h2 = 26.0
            case h3 = 24.0
            case h4 = 20.0
			case h5 = 18.0
            //body sizes
            case b0 = 15.0
            case b1 = 14.0
            case b2 = 12.0
            case b3 = 11.0
			case b4 = 10.0
			case b5 = 8.0
        }
        
        enum FontSize {
            case Standard(StandardSizes)
            case Custom(CGFloat)
            
            var value: CGFloat {
                switch self {
                case .Standard(let size):
                    switch UIDevice.current.screenType.rawValue {
                    case UIDevice.ScreenType.iPhones_5_5s_5c_SE.rawValue:
                        return size.rawValue * 0.8
                    case UIDevice.ScreenType.iPhoneXSMax.rawValue, UIDevice.ScreenType.iPhoneXR.rawValue:
                        return size.rawValue * 1.2
                    case UIDevice.ScreenType.iPad97.rawValue:
                        return size.rawValue * 1.2
                    case UIDevice.ScreenType.iPadPro129.rawValue, UIDevice.ScreenType.iPadPro105.rawValue, UIDevice.ScreenType.iPadPro11.rawValue:
                        return size.rawValue * 1.4
                    default:
                        return size.rawValue
                    }
                case .Custom(let customSize):
                    return customSize
                }
            }
        }
    }
  
	
}
