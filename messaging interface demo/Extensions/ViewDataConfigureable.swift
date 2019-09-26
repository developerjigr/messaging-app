//
//  UIView+ViewDataConfigurable.swift
//  messaging interface demo
//
//  Created by Jigar Polra on 14/09/2019.
//  Copyright © 2019 JIG_R. All rights reserved.
//

import Foundation

protocol ViewData {}

protocol ViewDataConfigurable {
	associatedtype ViewDataType = ViewData
	func configureView(with viewData: ViewDataType)
}


