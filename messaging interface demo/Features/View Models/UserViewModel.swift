//
//  UserViewModel.swift
//  messaging interface demo
//
//  Created by Jigar Polra on 14/09/2019.
//  Copyright © 2019 JIG_R. All rights reserved.
//

import Foundation

protocol UserViewModelDelegate {

}

struct UserViewData {

}

class UserViewModel {

	static var mockedLoggedInUser = User.init(
		firstName: "Mock",
		lastName: "Recevier",
		userImageURL: "No Image",
		conversationList: []
	)

	func appendMessageData(with message: MessageModel) {

	}
}
