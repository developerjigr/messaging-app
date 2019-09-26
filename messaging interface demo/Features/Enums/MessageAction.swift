//
//  MessageActionEnum.swift
//  messaging interface demo
//
//  Created by Jigar Polra on 14/09/2019.
//  Copyright © 2019 JIG_R. All rights reserved.
//

import Foundation

enum MessageAction {
	case outdatedMessage
	case mostRecentMessage
	case carryingConversation
	case sent
	case delivered

}

extension MessageAction {
	func debugAction() {
		var debugMessage: String = ""
		switch self {
		default:
			debugMessage = "Message has been \(MessageStatus.undelivered.rawValue)"
		}
		print(debugMessage.appendTimestamp())
	}
}
