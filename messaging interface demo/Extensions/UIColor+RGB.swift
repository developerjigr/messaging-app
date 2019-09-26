//
//  UIColor+RGB.swift
//  messaging interface demo
//
//  Created by Jigar Polra on 15/09/2019.
//  Copyright © 2019 JIG_R. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {

	convenience init(r: CGFloat, g: CGFloat, b: CGFloat) {
		self.init(
			displayP3Red: r/255,
			green: g/255,
			blue: b/255,
			alpha: 1
		)
	}

	class var mPink: UIColor {
		return UIColor.init(
			r: 251,
			g: 64,
			b: 107
		)
	}

	class var mGray: UIColor {
		return UIColor.init(
			r: 239,
			g: 237,
			b: 238
		)
	}
}
