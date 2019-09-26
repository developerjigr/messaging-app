//
//  MessageTableViewCellContent.swift
//  messaging interface demo
//
//  Created by Jigar Polra on 14/09/2019.
//  Copyright © 2019 JIG_R. All rights reserved.
//

import Foundation
import UIKit

protocol MessageTableCellViewProtocol {
	var messageViewModel: MessageViewModel? { get set }
	var delegate: MessageViewModelDelegate? { get set }

	func setAlignment(for initiator: MessageIntitiator)
	func setBackgroundColor(for messageType: MessageType)
	func setViewColors(for messageType: MessageIntitiator)
	func setupView()
	func setMessageContent(message: String, label: String)
	func setDeliveryStatus(isDelivered: Bool)
	func setMessageStatus(isShown: Bool)

}

class MessageTableViewCell: UITableViewCell, MessageViewModelDelegate, MessageTableCellViewProtocol {

	var messageViewModel: MessageViewModel?
	var delegate: MessageViewModelDelegate?

	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
	}

	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}

	func setupView() {}

	func setAlignment(for initiator: MessageIntitiator) {

	}

	func setBackgroundColor(for messageType: MessageType) {

	}

	func setViewColors(for messageType: MessageIntitiator) {

	}

	func setMessageContent(message: String, label: String) {

	}

	func setDeliveryStatus(isDelivered: Bool) {

	}

	func setMessageStatus(isShown: Bool) {

	}


	func messageView(_ messageViewModel: MessageViewModel, viewDataDidUpdate messageViewData: MessageTableCellViewData?) {
		guard let viewData = messageViewData else {
			return
		}
		configureView(with: viewData)
	}


}

enum MessageIntitiator {
	case sender
	case receiver
}

extension MessageTableViewCell: ViewDataConfigurable {

	typealias ViewDataType = MessageTableCellViewData

	func configureView(with viewData: MessageTableCellViewData) {
		let messageType = viewData.isMessageOwner ? MessageIntitiator.sender : MessageIntitiator.receiver
		setAlignment(for: messageType)
		setViewColors(for: messageType)
		setMessageContent(message: viewData.content, label: viewData.messageStatus)
		setDeliveryStatus(isDelivered: viewData.isMessageDelivered)
		setMessageStatus(isShown: viewData.isMostRecentMessage)
		setupView()
		contentView.transform = CGAffineTransform.init(scaleX: 1, y: -1)
		contentView.layer.cornerRadius = 12
	}
}




