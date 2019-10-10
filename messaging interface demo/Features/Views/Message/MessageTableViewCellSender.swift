//
//  MessageTableViewCellContent.swift
//  messaging interface demo
//
//  Created by Jigar Polra on 14/09/2019.
//  Copyright © 2019 JIG_R. All rights reserved.
//

import Foundation
import UIKit

class MessageTableViewCellSender: MessageTableViewCell, NibLoadable {

	@IBOutlet var containerView: UIView!
	@IBOutlet var stackView: UIStackView!
	@IBOutlet var messageContainerView: UIView!
	@IBOutlet var messageContent: UITextView!

	@IBOutlet var messageStatusContainerView: UIView!
	@IBOutlet var messageStatusLabel: UILabel!

	private enum Constant {
		static let reuseIdentifier = "MessageTableViewCellContentView"

		static let senderBackgroundColor: UIColor = .mGray
		static let receiverBackgroundColor: UIColor = .mPink
		static let multimediaBackgroundColor: UIColor = .clear

		static let receiverTextColor: UIColor = .white
		static let senderTextColor: UIColor = .black

		static let maxMessagePadding: CGFloat = 100

		static let senderAlignment: NSTextAlignment = .left
		static let receiverAlignment: NSTextAlignment = .right

		static let cornerRadius: CGFloat = 12.0
		static let messageContentContainerPadding: CGFloat = 12.0
		static let bezierPointLength: CGFloat = 16.0
	}

	private var shouldShowMessageTail: Bool = false {
		willSet {
			if shouldShowMessageTail == true {
				return
			}
		}
	}
	private var messageType: MessageIntitiator = .sender


	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
	}

	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}

	override func awakeFromNib() {
		super.awakeFromNib()
	}

	override func setupView() {
		messageContainerView.layer.cornerRadius = 12
	}

	override func setViewColors(for initiator: MessageIntitiator) {
		messageContainerView.backgroundColor = Constant.senderBackgroundColor
		messageContent.textColor = Constant.senderTextColor
	}

	override func setAlignment(for initiator: MessageIntitiator) {
		messageStatusLabel.textAlignment = Constant.senderAlignment
		stackView.semanticContentAttribute = .forceLeftToRight
	}

	override func setBackgroundColor(for messageType: MessageType) {
		switch messageType {
		case .text:
			break
		case .multimedia:
			messageContainerView.backgroundColor = .clear
		}
	}

	override func setMessageStatus(isShown: Bool) {
		messageStatusContainerView.isHidden = !isShown
	}

	override func setMessageContent(message: String, label: String) {
		messageContent.text = message
		messageStatusLabel.text = label
	}

	override func setDeliveryStatus(isDelivered: Bool) {
		shouldShowMessageTail = isDelivered
	}

	override func draw(_ rect: CGRect) {
		guard shouldShowMessageTail else {
			return
		}

		let guideFrame = self.frame
		var targetFrame = messageContainerView.frame

		let mScale: CGFloat
		let fillColor: UIColor
		let bezierEndDistance: CGFloat

		let xPadding:CGFloat
		let yPadding:CGFloat = abs(targetFrame.height - guideFrame.height) - 4

		mScale = -1
		fillColor = UIColor.mGray
		bezierEndDistance = Constant.bezierPointLength
		xPadding = Constant.messageContentContainerPadding

		targetFrame = targetFrame.offsetBy(
			dx: xPadding,
			dy: yPadding
		)

		let startPoint = CGPoint(x: targetFrame.minX + 8.0, y: targetFrame.minY + 4)

		let bezierPath = UIBezierPath(roundedRect: targetFrame, cornerRadius: Constant.cornerRadius)

		bezierPath.move(to: startPoint)
		bezierPath.addLine(to: CGPoint(
			x: startPoint.x,
			y: startPoint.y + bezierEndDistance)
		)
		bezierPath.addCurve(
			to: CGPoint(
				x: startPoint.x + (bezierEndDistance * mScale),
				y: startPoint.y
			),
			controlPoint1:  CGPoint(
				x: startPoint.x + ((bezierEndDistance/2) * mScale),
				y: startPoint.y + (bezierEndDistance/2)
			),
			controlPoint2:  CGPoint(
				x: startPoint.x + ((bezierEndDistance/2) * mScale),
				y: startPoint.y + (bezierEndDistance/4)
			)
		)
		fillColor.setFill()
		bezierPath.fill()
		bezierPath.close()
	}
}



