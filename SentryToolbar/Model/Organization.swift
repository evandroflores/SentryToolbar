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
    var projects: [String: Project]
    
    init (slug: String, token: String, projects: [String: Project]){
        self.slug = slug
        self.token = token
        self.projects = projects
    }

    func getTotalIssues() -> Int64 {
        var total = Int64(0)
        for (_, project) in projects {
            total += project.getEventSum()
        }
        return total
    }
}
