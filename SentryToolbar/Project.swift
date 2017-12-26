//
//  Project.swift
//  SentryToolbar
//
//  Created by Evandro Flores on 26/12/2017.
//  Copyright © 2017 Evandro Flores. All rights reserved.
//

import Foundation

struct Project : Codable {
    let slug: String
    let query: String
    
    init(slug: String, query: String){
        self.slug = slug
        self.query = query
    }

    func getQuery() -> String {
        if !self.query.isEmpty {
            return "?query=\(self.query)"
        } else {
            return ""
        }
    }
}
