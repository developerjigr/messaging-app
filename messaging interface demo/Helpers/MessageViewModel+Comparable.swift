//
//  MessageViewModel+Comparable.swift
//  messaging interface demo
//
//  Created by Jigar Polra on 17/09/2019.
//  Copyright © 2019 JIG_R. All rights reserved.
//

import Foundation

extension MessageViewModel: Comparable {

	static func < (lhs: MessageViewModel, rhs: MessageViewModel) -> Bool {
		guard
			let lhsDate = lhs.sentDate?.convertToDate(),
			let rhsDate = rhs.sentDate?.convertToDate()
		else {
			return false
		}
		return lhsDate < rhsDate
	}

	static func == (lhs: MessageViewModel, rhs: MessageViewModel) -> Bool {
		return lhs.sentDate == rhs.sentDate
	}
}
