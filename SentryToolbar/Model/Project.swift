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
        self.warnNewIssuesOrCount()
    }

    func warnNewIssuesOrCount(){
        let lastRun = Date().addingTimeInterval(Config.LOOP_CYCLE_SECONDS * -1)
        for issue in issues!{
            let diff = issue.lastSeen.timeIntervalSince(lastRun)
            if diff > 0 {
                var notificationData: [String: Any]
                if issue.firstSeen == issue.lastSeen {
                    NSLog("NEW ISSUE \(diff) \(issue)")
                    notificationData = ["type": NotificationHandler.NEW_ISSUE, "issue": issue]
                }else{
                    NSLog("NEW ISSUE COUNT since last check \(diff) \(issue)")
                    notificationData = ["type": NotificationHandler.NEW_COUNT, "issue": issue]
                }
                NotificationCenter.default.post(name: Notification.Name(NotificationHandler.NotificationSig), object: nil, userInfo: notificationData)
            }
        }
    }
}
