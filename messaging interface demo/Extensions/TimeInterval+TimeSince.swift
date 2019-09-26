//
//  TimeInterval+TimeSince.swift
//  messaging interface demo
//
//  Created by Jigar Polra on 21/09/2019.
//  Copyright © 2019 JIG_R. All rights reserved.
//

import Foundation

extension TimeInterval {

	enum IntervalType {
		case hour
		case minutes
		case seconds
	}

	func differenceFromNow(intervalType: IntervalType) -> Int {
		let timeIntervalNow = Date().timeIntervalSince1970
		return (timeIntervalNow - self).convertedTo(intervalType: intervalType)
	}

	func convertedTo(intervalType: IntervalType) -> Int {
		let seconds = CLong(self) // Since modulo operator (%) below needs int or long
		switch intervalType {
		case .hour:
			return seconds / 3600;
		case .minutes:
			return (seconds % 3600) / 60;
		case .seconds:
			return seconds % 60;
		}
	}
}
