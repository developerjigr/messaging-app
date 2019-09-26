//
//  User.swift
//  messaging interface demo
//
//  Created by Jigar Polra on 14/09/2019.
//  Copyright © 2019 JIG_R. All rights reserved.
//

import Foundation

struct User: Codable {
	let firstName: String
	let lastName: String
	let userImageURL: String
	let conversationList: [ConversationsModel]

	func fullName() -> String {
		return self.firstName + self.lastName
	}
}

extension User {

	static func getUser() -> User {
		return User.init(
			firstName: "Mock",
			lastName: "Sender",
			userImageURL: "sds",
			conversationList: []
		)
	}

	static func getCurrentUserProfile() -> UserProfile {
		let user = getUser()
		return UserProfile.init(
			firstName: user.firstName,
			lastName: user.lastName,
			userImageURL: user.userImageURL
		)
	}

}



