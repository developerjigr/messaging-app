//
//  UINavigationBar+RemoveBorder.swift
//  messaging interface demo
//
//  Created by Jigar Polra on 15/09/2019.
//  Copyright © 2019 JIG_R. All rights reserved.
//

import UIKit

extension UINavigationBar {
	func removeShadowBorder() {
		self.setBackgroundImage(UIImage(), for:.default)
		self.shadowImage = UIImage()
		self.layoutIfNeeded()
	}

	func restoreShadowBorder() {
		self.setBackgroundImage(nil, for:.default)
		self.shadowImage = nil
		self.layoutIfNeeded()
	}

}

