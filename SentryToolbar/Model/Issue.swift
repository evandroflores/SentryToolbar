//
//  Issue.swift
//  SentryToolbar
//
//  Created by Evandro Flores on 26/12/2017.
//  Copyright © 2017 Evandro Flores. All rights reserved.
//

import Foundation

struct Issue : Codable {
    let id: String
    let shortId: String
    let title: String
    let count: String
    let lastSeen: String
    let firstSeen: String
}
