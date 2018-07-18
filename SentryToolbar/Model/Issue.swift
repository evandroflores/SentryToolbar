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

    static func decoder() -> JSONDecoder {
        let decoder = JSONDecoder()
        let dateFormat = DateFormatter()
        dateFormat.timeZone = TimeZone(identifier: "GMT")
        dateFormat.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z"
        decoder.dateDecodingStrategy = .formatted(dateFormat)
        return decoder
    }
}
