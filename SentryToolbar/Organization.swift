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
    let projects: [Project]
    
    init (slug: String, token: String, projects: [Project]){
        self.slug = slug
        self.token = token
        self.projects = projects
    }
}
