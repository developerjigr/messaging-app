//
//  String+TimeStamp.swift
//  messaging interface demo
//
//  Created by Jigar Polra on 14/09/2019.
//  Copyright © 2019 JIG_R. All rights reserved.
//

import Foundation


extension String {

	func appendTimestamp() -> String {
		return self + Date.toStringFormatted()
	}

	func fromKeyFormatToTodayYesterdayFormat() -> String {
		guard let keyFormatDate = self.convertToDate(.keyFormat) else {
			assertionFailure("String+DateFormat: unable to convert \(self)")
			return ""
		}
		return keyFormatDate.toStringFormatted(
			format: .headerViewFormat,
			todayOrYesterdayFormat: true
		)
	}

	func convertToDate(_ format: Date.Format = .defaultDateFormat) -> Date? {
		let dateFormatter = DateFormatter()
		dateFormatter.calendar = Calendar.current
		dateFormatter.locale = Locale(identifier: Date.Constant.defaultLocale)
		dateFormatter.dateFormat = format.rawValue
		guard let date = dateFormatter.date(from: self) else {
			return nil
		}
		return date
	}

	func convertToDate(from format: Date.Format) -> Date? {
		let dateFormatter = DateFormatter()
		dateFormatter.calendar = Calendar.current
		dateFormatter.locale = Locale(identifier: Date.Constant.defaultLocale)
		dateFormatter.dateFormat = format.rawValue
		guard let date = dateFormatter.date(from: self) else {
			
			return nil
		}
		return date
	}

	func convertDateToDefaultStringFormatted() -> String {
		guard let convertedFormat = self.convertToDate()?.toStringFormatted() else {
			return "invalid date"
		}
		return convertedFormat
	}

	func convertDateToDefaultString() -> String {
		guard let convertedFormat = self.convertToDate()?.description else {
			return "invalid date"
		}
		return convertedFormat
	}

	func convertAndFormatDateForGrouping() -> Date {
		guard let convertedDate = self.convertToDate() else {
			fatalError("Unable to convert and group '\(self)' to date.")
		}
		return convertedDate.formatForGrouping(date: convertedDate)
	}

	func convertAndFormatDateForHeaderViewFormat() -> String {
		guard
			let convertedDate = self.convertToDate(.keyFormat),
			let formattedDateToString = convertedDate.toStringKeyFormat()
		else {
			assertionFailure("Unable to convert and group '\(self)' to date.")
			return ""
		}
		return formattedDateToString
	}

}


extension DateFormatter {

	//TODO: Can be refactored -> Add guards and remove unwraps
	func string(from date: Date, todayOrYesterdayFormat: Bool) -> String? {
		guard todayOrYesterdayFormat else {
			return self.string(from: date)
		}
		let calendar = Calendar(identifier: .iso8601)
		if calendar.isDateInToday(date) {
			self.dateFormat = Date.Constant.TodayDateInStringFormat
			return self.string(from: date)
		} else if calendar.isDateInYesterday(date) {
			self.dateFormat = Date.Constant.YesterdayDateInStringFormat
			return self.string(from: date)
		} else {
			self.dateFormat = Date.Format.headerViewFormat.rawValue
			return self.string(from: date)
		}
	}
}
