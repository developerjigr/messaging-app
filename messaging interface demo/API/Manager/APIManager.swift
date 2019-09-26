//
//  APIManager.swift
//  messaging interface demo
//
//  Created by Jigar Polra on 15/09/2019.
//  Copyright © 2019 JIG_R. All rights reserved.
//

import Foundation

enum APIError: String, Error {
	case noNetwork = "No Network"
	case serverOverload = "Server is overloaded"
	case permissionDenied = "You don't have permission"
}

protocol APIServiceProtocol {
	func fetchConversationList(complete: @escaping (_ success: Bool, _ Conversations: [ConversationModel], _ error: APIError?)->() )
}

class APIManager: APIServiceProtocol {

	enum Constant {
		static let resource: String = "content"
		static let resourceType: String = "json"
	}

	static let shared = APIManager()

	private init() {
		print("APIService Initialized...")
	}

	// Simulate a long waiting for fetching
	func fetchConversationList(
		complete: @escaping (
		_ success: Bool,
		_ Conversations: [ConversationModel],
		_ error: APIError?)->()
		) {
		DispatchQueue.global().async {
			sleep(1)
			let path = Bundle.main.path(
				forResource: Constant.resource,
				ofType: Constant.resourceType
			)!
			let data = try! Data(contentsOf: URL(fileURLWithPath: path))
			let decoder = JSONDecoder()
			decoder.dateDecodingStrategy = .iso8601
			let conversationsList = try! decoder.decode(ConversationsModel.self, from: data)
			complete(true, conversationsList.conversations, nil)
		}
	}



}
