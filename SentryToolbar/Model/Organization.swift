//
//  Organization.swift
//  SentryToolbar
//
//  Created by Evandro Flores on 26/12/2017.
//  Copyright © 2017 Evandro Flores. All rights reserved.
//

import Foundation

struct Organization : Codable {
    let slug: String
    let token: String
    var projects: [Project]
    
    init (slug: String, token: String, projects: [Project]){
        self.slug = slug
        self.token = token
        self.projects = projects
    }

    func getTotalIssues() -> Int64 {
        var total = Int64(0)
        for project in projects {
            total += project.getTotalIssues()
        }
        return total
    }
}
