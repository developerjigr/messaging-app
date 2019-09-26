//
//  MessageModel.swift
//  messaging interface demo
//
//  Created by Jigar Polra on 14/09/2019.
//  Copyright © 2019 JIG_R. All rights reserved.
//

import Foundation

enum MessageType: String {
	case text
	case multimedia
}

struct MessageGroupModel: Codable {
	let group: String
	let messages: [MessageModel]
}

struct MessageModel: Codable {

	var description: String {
		return messageBody ?? ""
	}

	let receivedDate: String?
	let sentDate: String?
	let messageSender: UserProfile?
	let messageType: String?
	let messageBody: String?
	let messageStatus: String?

}


//{
//	 "receivedDate": "10/01/2019:14:15"
//	 "sentDate": "10/01/2019:14:12"
//	"messageSender": {
//		"firstName": "Mock",
//		"lastName": "Sender"
//		"userImageURL": "https://image.shutterstock.com/image-vector/man-avatar-profile-picture-vector-260nw-229692004.jpg"
//	},
//	 "messageType": "text",
//	 "messageBody": "This is a test message.",
//	 "messageStatus": "sent",
//}
