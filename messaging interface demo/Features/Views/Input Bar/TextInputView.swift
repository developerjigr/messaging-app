//
//  TextInputView.swift
//  messaging interface demo
//
//  Created by Jigar Polra on 17/09/2019.
//  Copyright © 2019 JIG_R. All rights reserved.
//

import Foundation
import InputBarAccessoryView

class TextInputView: InputBarAccessoryView {

	override init(frame: CGRect) {
		super.init(frame: frame)
		configure()
	}

	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}

	func configure() {
		inputTextView.backgroundColor = UIColor(red: 250/255, green: 250/255, blue: 250/255, alpha: 1)
		inputTextView.placeholderTextColor = UIColor(red: 0.6, green: 0.6, blue: 0.6, alpha: 1)
		inputTextView.textContainerInset = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 36)
		inputTextView.placeholderLabelInsets = UIEdgeInsets(top: 8, left: 20, bottom: 8, right: 36)
		inputTextView.layer.borderColor = UIColor(red: 200/255, green: 200/255, blue: 200/255, alpha: 1).cgColor
		inputTextView.layer.borderWidth = 1.0
		inputTextView.layer.cornerRadius = 16.0
		inputTextView.layer.masksToBounds = true
		inputTextView.scrollIndicatorInsets = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)
		setRightStackViewWidthConstant(to: 38, animated: false)
		setStackViewItems([sendButton, InputBarButtonItem.fixedSpace(2)], forStack: .right, animated: false)

		sendButton.imageView?.backgroundColor = tintColor
		sendButton.contentEdgeInsets = UIEdgeInsets(top: 2, left: 2, bottom: 2, right: 2)
		sendButton.setSize(CGSize(width: 56, height: 44), animated: false)
		sendButton.image = nil
		sendButton.title = "Send"
		sendButton.imageView?.layer.cornerRadius = 16
		sendButton.backgroundColor = .clear
		middleContentViewPadding.right = -38
		separatorLine.isHidden = true
		isTranslucent = true
	}

}
