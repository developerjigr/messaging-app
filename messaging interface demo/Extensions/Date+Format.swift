//
//  Date+Format.swift
//  messaging interface demo
//
//  Created by Jigar Polra on 16/09/2019.
//  Copyright © 2019 JIG_R. All rights reserved.
//

import Foundation

extension Date {

	enum Format: String {
		case defaultDateFormat = "dd'/'MM'/'yyyy':'HH':'mm':'ss"
		case keyFormat = "dd'/'MM'/'yyyy':'HH:mm"
		case headerViewFormat = "dd'/'MM'/'yy' 'HH:mm"
	}

	enum Constant {
		static let defaultLocale: String = "en_gb"

		static let TodayDateInStringFormat: String = "'Today 'HH':'mm"
		static let YesterdayDateInStringFormat: String = "'Yesterday 'HH:mm"
	}

	func formatForGrouping(date : Date) -> Date {
		let calendar = Calendar.current
		let components = calendar.dateComponents([.year, .month, .day], from: date)

		return calendar.date(from: components)!
	}

	func toStringKeyFormat() -> String? {
		return self.toStringFormatted(format: .keyFormat)
	}

	func toStringFormatted(
		format: Date.Format = .defaultDateFormat,
		todayOrYesterdayFormat: Bool = false
	) -> String {
		let dateFormatter = DateFormatter()
		dateFormatter.locale = Locale(identifier: Constant.defaultLocale)
		dateFormatter.dateFormat = format.rawValue
		return dateFormatter.string(from: self, todayOrYesterdayFormat: todayOrYesterdayFormat) ?? "INVALID VALUE"
	}

	var hour: Int? {
		let calendar = Calendar.current
		let components = calendar.dateComponents([.hour], from: self)
		return components.hour
	}

	var seconds: Int? {
		let calendar = Calendar.current
		let components = calendar.dateComponents([.second], from: self)
		return components.second
	}

	var isToday: Bool {
		let calendar = Calendar.current
		return calendar.isDateInToday(self)
	}

	static func toStringFormatted(_ format: Date.Format = .defaultDateFormat) -> String {
		let dateFormatter = DateFormatter()
		let date = Date()
		dateFormatter.locale = Locale(identifier: Constant.defaultLocale)
		dateFormatter.dateFormat = format.rawValue
		return dateFormatter.string(from: date)
	}

	func formatToShortDate() -> String {
		return self.toStringFormatted()
	}
}
