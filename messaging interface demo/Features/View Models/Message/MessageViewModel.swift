//
//  MessageViewModel.swift
//  messaging interface demo
//
//  Created by Jigar Polra on 14/09/2019.
//  Copyright © 2019 JIG_R. All rights reserved.
//

import Foundation
import UIKit

protocol APIModel {

}

struct MessageTableCellViewData: ViewData {
	let content: String
	var messageStatus: String
	let isMessageOwner: Bool
	let isMultimedia: Bool
	var isMostRecentMessage: Bool
	var isMessageDelivered: Bool
}

protocol MessageViewModelDelegate: class {
	func messageView(_ messageViewModel: MessageViewModel, viewDataDidUpdate messageViewData: MessageTableCellViewData?)
}

protocol MessageViewModelInterface {
	func updateMessageStatus(with action: MessageAction)
	func viewData() -> MessageTableCellViewData? //TODO undo optional
	func formattedMessageStatus() -> String
}

class MessageViewModel {

	var heightForRow: CGFloat? = nil

	private enum Constant {
		static let invalidMessageStampText = "Invalid message stamp returned."
		static let messageErrorObjectNilError = "Something went wrong when tryting to convert message user to string."
		static let getViewDataErrorMessage = "MessageViewModel: Unable to get view data from model."
	}

	var delegate: MessageViewModelDelegate? {
		didSet {
			delegate?.messageView(self, viewDataDidUpdate: messageViewData)
		}
	}

	var messageViewData: MessageTableCellViewData? {
		return updateViewData()
	}

	let keyGroup: String?
	var messageModel: MessageModel?
	var isMostRecentMessage: Bool = false
	var sentPreviousMessage: Bool = false

	var isMessageDelivered: Bool {
		var hasSentOverTwentySeconds: Bool = false
		if let sentDate = messageModel?.sentDate?.convertToDate(.defaultDateFormat) {
			hasSentOverTwentySeconds = Date().timeIntervalSince(sentDate).convertedTo(intervalType: .seconds) >= 20
		}
		return isMostRecentMessage || hasSentOverTwentySeconds || sentPreviousMessage
	}

	var messageText: String?
	var receivedDate: String? {
		return messageModel?.receivedDate
	}

	var sentDate: String? {
		return messageModel?.sentDate
	}

	init(with messageModel: MessageModel, keyGroup: String) {
		self.keyGroup = keyGroup
		self.messageModel = messageModel
	}

	init(with messageText: String, keyGroup: String) {
		self.keyGroup = keyGroup
		self.messageText = messageText
		self.messageModel = MessageModel.init(
			receivedDate: nil,
			sentDate: Date().toStringFormatted(),
			messageSender: User.getCurrentUserProfile(),
			messageType: "text",
			messageBody: messageText,
			messageStatus: "Sent"
		)

	}

	func updateMessageStatus(with action: MessageAction) {
		switch action {
		case .outdatedMessage:
			isMostRecentMessage = false
			break
		case .mostRecentMessage:
			isMostRecentMessage = true
			break
		case .delivered:
			
			break
		default:
			break
		}

		guard let delegate = delegate else {
			print("delegate nt set")
			return
		}
		delegate.messageView(self, viewDataDidUpdate: messageViewData)

	}

	//TODO: Work on the logic for the message format string
	func formattedMessageStatus() -> String {
		return isMessageDelivered ? "Delivered" : "Sent"
	}

	//TODO
	func updateViewData() -> MessageTableCellViewData {
		guard
			let messageContent = messageModel?.messageBody,
			let messageOwner = messageModel?.messageSender,
			let messageOwnerStatus = isMessageOwner(user: messageOwner),
			let messageType = messageModel?.messageType?.convertToMessageType()
		else {
			fatalError(Constant.getViewDataErrorMessage.appendTimestamp())
		}

		let isMessageMutlimedia = isMessageTypeMultimedia(type: messageType)
		let formattedMessageStatus = self.formattedMessageStatus()

		return MessageTableCellViewData(
			content: messageContent,
			messageStatus: formattedMessageStatus,
			isMessageOwner: messageOwnerStatus,
			isMultimedia: isMessageMutlimedia,
			isMostRecentMessage: isMostRecentMessage,
			isMessageDelivered: isMessageDelivered
		)
	}

}

extension MessageViewModel {
	private func isMessageTypeMultimedia(type messageType: MessageType) -> Bool {
		return messageType != .multimedia
	}

	private func isMessageOwner(user: UserProfile?) -> Bool? {
		guard let messageUser = user else {
			fatalError(Constant.messageErrorObjectNilError)
		}
		let loggedInUser = UserViewModel.mockedLoggedInUser
		if loggedInUser.fullName() == (messageUser.firstName + messageUser.lastName) {
			return true
		}
		return false
	}
}


