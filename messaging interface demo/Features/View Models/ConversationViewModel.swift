//
//  ConversationViewModel.swift
//  messaging interface demo
//
//  Created by Jigar Polra on 15/09/2019.
//  Copyright © 2019 JIG_R. All rights reserved.
//

import Foundation
import UIKit

protocol ConversationViewDelegate: class {
	func conversation(_ conversationViewModel: ConversationViewModel, didLoadConversation: ConversationViewData)
	func conversation(_ conversationViewModel: ConversationViewModel, didAddMessage: MessageViewModel, at indexPath: IndexPath, needsNewSection: Bool)
}

struct ConversationViewData {
	let senderName: String
	let receiverName: String
	var messages: Dictionary<String, [MessageViewModel]>
	var lastConversatonDate: String
	var currentConversationDate: String
}

class ConversationViewModel {

	var conversationList: [ConversationModel] = [] {
		didSet {
			loadInitialConversation()
		}
	}

	weak var delegate: ConversationViewDelegate?
	var apiManager: APIServiceProtocol?
	var conversationViewData: ConversationViewData?

	var numberOfSections: Int {
		return conversationViewData?.messages.keys.count ?? 1
	}

	init(with delegate: ConversationViewDelegate, apiManager: APIServiceProtocol?) {
		self.delegate = delegate
		self.apiManager = apiManager
		fetchConversationData()
	}


	fileprivate func fetchConversationData() {
		guard let apiManager = apiManager else {
			fatalError("Error with accessing APIManager: ConversationViewModel")
		}
		apiManager.fetchConversationList { [weak self] (success, conversationList, error) in
			guard
				!conversationList.isEmpty,
				error == nil
			else {
				print("Problem with initial fetch... Error: \(String(describing: error?.rawValue))")
				return
			}
			self?.conversationList = conversationList
		}
	}

	fileprivate func loadInitialConversation() {
		guard let viewData = conversationViewData(at: 0) else {
			return
		}
		conversationViewData = viewData
		delegate?.conversation(self, didLoadConversation: viewData)
	}

	func conversationViewData(at index: Int) -> ConversationViewData? {
		guard let conversation = conversationList[index] as? ConversationModel else {
			print("Conversation out of bounds at index: \(index)")
			return nil
		}

		var messageGroupDict: [String: [MessageViewModel]] = [:]
		conversation.messageGroups.forEach { messageGroup in
			let viewModels: [MessageViewModel] = messageGroup.messages.map { return MessageViewModel(with: $0, keyGroup: messageGroup.group)}
			viewModels.sorted(by: <).last?.isMostRecentMessage = true
			messageGroupDict.updateValue(viewModels, forKey: messageGroup.group)
		}

		//messageGroupDict = messageGroupDict.mapValues({ $0.sorted(by: <)})
		let dateForLastConversation = keyForLastConversation(using: Array(messageGroupDict.keys))
		let currentConversationDate = keyForCurrentConversation() ?? Date().toStringKeyFormat()!

		let conversationViewData = ConversationViewData.init(
			senderName: conversation.receivedBy.firstName,
			receiverName: conversation.startedBy.firstName,
			messages: messageGroupDict,
			lastConversatonDate: dateForLastConversation,
			currentConversationDate: currentConversationDate
		)
		return conversationViewData
	}

	func headerTitle(for section: Int) -> String {
		guard let keyForSection = key(for: section) else {
			return ""
		}
		return keyForSection.fromKeyFormatToTodayYesterdayFormat()
	}

	func messageViewModel(at indexPath: IndexPath) -> MessageViewModel? {
		guard
			let conversationViewData = conversationViewData,
			let keyForSection = key(for: indexPath.section)
		else {
			print("Unable to get message at indexRow \(indexPath.row)")
			return nil
		}
		guard
			let conversationMessages = conversationViewData.messages[keyForSection]?.reversed()
		else {
			print("Unable to get message for section Key \(keyForSection), sectionId \(indexPath.section) at indexRow \(indexPath.row)")
			return nil
		}
		return Array(conversationMessages)[indexPath.row]
	}

	func lastMessageSent() -> MessageViewModel? {
		guard
			let lastConvoKey = conversationViewData?.lastConversatonDate,
			let viewModels = conversationViewData?.messages[lastConvoKey],
			let messageModel = viewModels.sorted(by: >).first
		else {
			return nil
		}
		return messageModel
	}

	func addMessageToCurrentConversation(with text: String) {
		guard
			!text.isEmpty,
			var currentKey = keyForCurrentConversation()
		else {
			return
		}

		let previousMessage = lastMessageSent()

		let shouldInsertNewSection = needsNewSection(for: currentKey)
		var messagesAtCurrentConversation = conversationViewData?.messages[currentKey] ?? []
		let messageVM = MessageViewModel.init(with: text, keyGroup: currentKey)
		messageVM.updateMessageStatus(with: .mostRecentMessage)
		if !shouldInsertNewSection {
			updateMessage(message: previousMessage)
			messagesAtCurrentConversation.append(messageVM)
			conversationViewData?.messages.updateValue(messagesAtCurrentConversation, forKey: currentKey)
		} else {
			currentKey = keyForCurrentConversationNeedsUpdate()!
			conversationViewData?.messages.updateValue([messageVM], forKey: currentKey)
		}
		conversationViewData?.lastConversatonDate = currentKey
		delegate?.conversation(self, didAddMessage: messageVM, at: currentMessageIndexPath, needsNewSection: shouldInsertNewSection)
	}

	var currentMessageIndexPath: IndexPath = {
		return IndexPath(row: 0, section: 0)
	}()

}

	// MARK: - Key Conversations / Handling
extension ConversationViewModel {

	func updateMessage(message: MessageViewModel?) {
		guard let lastMessage = message else {
			return
		}
		lastMessage.updateMessageStatus(with: .outdatedMessage)
	}

	//TODO: Add guards and remove force unwraps -> proper error handling etc
	func key(for sectionId: Int) -> String? {
		guard let sortedMessages = conversationViewData?.messages.sorted(
			by: { first, second in
				guard
					let firstDate = first.key.convertToDate(from: .keyFormat),
					let secondDate = second.key.convertToDate(from: .keyFormat)
				else {
					return false
				}
				return firstDate > secondDate
				}
			)
		else {
			return nil
		}
		return sortedMessages[sectionId].key
	}

	// Will either return the date of
	private func dateForCurrentConversation(using lastConversationDate: String?) -> Date {
		let dateNow = Date()
		guard
			let lastConversationDate = lastConversationDate?.convertToDate(.keyFormat),
			lastConversationDate.isToday,
			let keyForCurrentConversation = keyForCurrentConversation(),
			let conversationAtKey = conversationViewData?.messages[keyForCurrentConversation],
			!conversationAtKey.isEmpty
		else {
			return dateNow
		}
		guard
			let lastConversationHour = lastConversationDate.hour,
			let todayHour = dateNow.hour,
			todayHour > lastConversationHour
		else {
			return lastConversationDate
		}
		return dateNow
	}

	// Check to see if there is last conversation, or if its been an hour
	func needsNewSection(for currentKey: String) -> Bool {
		guard let _ = conversationViewData?.lastConversatonDate else {
			return true
		}
		guard
			let timeIntervalLast = lastMessageSent()?.sentDate?.convertToDate()?.timeIntervalSince1970,
			timeIntervalLast.differenceFromNow(intervalType: .minutes) < 1
		else {
				return true
		}
		guard !(conversationViewData?.messages[currentKey] ?? []).isEmpty else {
			return true
		}

		return false
	}

	func keyForCurrentConversationNeedsUpdate() -> String? {
		guard let dateNowToString = Date().toStringKeyFormat() else {
			return ""
		}
		conversationViewData?.currentConversationDate = dateNowToString
		return conversationViewData?.currentConversationDate
	}


	private func keyForLastConversation() -> String {
		guard let lastKey = conversationViewData?.lastConversatonDate else {
			return ""
		}
		return lastKey
	}

	private func keyForLastConversation(using keyDates: [String] = []) -> String {
		guard
			let lastKey = conversationViewData?.lastConversatonDate
		else {
			let newLastKey = keyDates.map({ $0.convertToDate(.keyFormat)!}
				).sorted(by: >).first?.toStringKeyFormat()
				conversationViewData?.lastConversatonDate = newLastKey!
				return newLastKey!
			}
		return lastKey
	}

	private func keyForConversation(using dateOfConversation: Date) -> String? {
		return dateOfConversation.toStringFormatted()
	}

	private func keyForCurrentConversation() -> String? {
		guard let currentKey = conversationViewData?.currentConversationDate else {
			if let lastConvoDate = conversationViewData?.lastConversatonDate {
				let newKey = dateForCurrentConversation(using: lastConvoDate).toStringKeyFormat()
				conversationViewData?.currentConversationDate = newKey ?? Date().toStringKeyFormat()!
				return newKey
			}
			return nil
		}
		return currentKey
	}

}

extension Sequence where Iterator.Element == (key: String, value: [MessageModel]) {

	private func getKeyValueFromIndex(for index: Int) -> String {
		let groupedMessageKeys = Array((self as? Dictionary<String, [MessageModel]>)!.keys)
		let keyForSection = groupedMessageKeys[index]
		return keyForSection as String
	}

}


