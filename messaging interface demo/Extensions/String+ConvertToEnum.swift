//
//  String+ConvertToEnum.swift
//  messaging interface demo
//
//  Created by Jigar Polra on 14/09/2019.
//  Copyright © 2019 JIG_R. All rights reserved.
//

import Foundation

extension String {
	func convertToMessageStatus() -> MessageStatus? {
		guard let messageActionEnum = MessageStatus(rawValue: self) else {
			return nil
		}
		return messageActionEnum
	}

	func convertToMessageType() -> MessageType? {
		guard let messageType = MessageType(rawValue: self) else {
			return nil
		}
		return messageType
	}
}
