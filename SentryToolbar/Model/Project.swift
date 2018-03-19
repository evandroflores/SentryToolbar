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
    var issues: [Issue]?
    
    init(slug: String, query: String){
        self.slug = slug
        self.query = query
        self.issues = []
    }

    func getQuery() -> String {
        if !self.query.isEmpty {
            return "?query=\(self.query)"
        } else {
            return ""
        }
    }

    func getTotalIssues() -> Int64 {
        var total = Int64(0)
        if self.issues != nil {
            for issue in self.issues! {
                total += Int64(issue.count)!
            }
        }
        NSLog("Project.getTotalIssues - Project [\(self.slug)] TotalIssues [\(total)] IssuesCount [\(self.issues?.count ?? 0)]")
        return total
    }

    mutating func updateIssues(newIssues: [Issue]){
        self.issues = newIssues
        // TODO: Check if the issue is new and alert

        let lastRun = Date().addingTimeInterval(Config.LOOP_CYCLE_SECONDS * -1)
        for issue in issues!{
            let diff = issue.lastSeen.timeIntervalSince(lastRun)
            NSLog("DATA DIFF \(lastRun) \(issue.lastSeen) \(diff)")
            if diff > 0 {
                NSLog("NEW ISSUE \(diff) \(issue)")
            }
        }
    }
}
