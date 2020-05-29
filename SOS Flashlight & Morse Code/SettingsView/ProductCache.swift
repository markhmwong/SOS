//
//  SharedCache.swift
//  SOS Flashlight & Morse Code
//
//  Created by Mark Wong on 25/5/20.
//  Copyright © 2020 Mark Wong. All rights reserved.
//

import UIKit //required by UIApplication

final class ProductCache: NSCache<NSString, AnyObject> {
	
	static let shared = ProductCache()
	
	private var memoryWarningObserver: NSObjectProtocol!
	
	private override init() {
        super.init()

		memoryWarningObserver = NotificationCenter.default.addObserver(forName:  UIApplication.didReceiveMemoryWarningNotification, object: nil, queue: nil) { [weak self] notification in
            self?.removeAllObjects()
        }
    }
	
	func storeCache(for key: NSString, object: AnyObject) {
		setObject(object, forKey: key)
	}
	
	func retrieveCache(for key: NSString) -> AnyObject {
		return object(forKey: key) as AnyObject
	}

//	func retrieveCache<T: AnyObject>(for key: NSString, completion: @escaping (T) -> ()) {
//		let obj = object(forKey: key)
//		completion(obj as! T)
//	}
	
	deinit {
        NotificationCenter.default.removeObserver(memoryWarningObserver)
    }
	
}
