//
//  ConversationList.swift
//  messaging interface demo
//
//  Created by Jigar Polra on 14/09/2019.
//  Copyright © 2019 JIG_R. All rights reserved.
//

import Foundation

struct ConversationModel: Codable {

	let startedBy: UserProfile
	let receivedBy: UserProfile
	let startDate: String
	let messageGroups: [MessageGroupModel]

}




