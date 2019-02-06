//
//  Issue.swift
//  SentryToolbar
//
//  Created by Evandro Flores on 26/12/2017.
//  Copyright © 2017 Evandro Flores. All rights reserved.
//

import Foundation

struct Issue: Codable {
    let id: String
    let title: String
    let count: String
    let userCount: Int
    let lastSeen: Date
    let firstSeen: Date
    let permalink: String

    enum DateError: String, Error {
        case invalidDate
        case unexpectedFormat
    }

    static func decoder() -> JSONDecoder {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .custom({ (decoder) -> Date in
            let container = try decoder.singleValueContainer()
            let dateStr = try container.decode(String.self)

            let formatter = DateFormatter()
            formatter.calendar = Calendar(identifier: .iso8601)
            formatter.locale = Locale(identifier: "en_US_POSIX")
            formatter.timeZone = TimeZone(secondsFromGMT: 0)

            try formatter.dateFormat = getFormatter(from: dateStr)

            if let date = formatter.date(from: dateStr) {
                return date
            }

            throw DateError.invalidDate
        })
        return decoder
    }

    func toNotification() -> [String: Any] {
        return [
            "type": self.firstSeen == self.lastSeen ?
                NotificationHandler.newIssueLabel:
                NotificationHandler.newEventCountLabel,
            "issue": self]
    }

    static func getFormatter(from dateStr: String) throws -> String {
        let dateFormat: String
        switch dateStr.count {
        case 10:
            dateFormat = "yyyy-MM-dd"
        case 16:
            dateFormat = "yyyy-MM-dd'T'HH:mm"
        case 19:
            dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        case 20:
            dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        case 23:
            dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS"
        case 24:
            dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        default:
            NSLog("DATE \(dateStr) Unexpected date format.")
            throw DateError.unexpectedFormat
        }
        return dateFormat
    }
}
