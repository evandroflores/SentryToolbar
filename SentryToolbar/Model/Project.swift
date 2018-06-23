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

    func getEventSum() -> Int64 {
        var totalEvents = Int64(0)
        if self.issues != nil {
            for issue in self.issues! {
                totalEvents += Int64(issue.count)!
            }
        }
        NSLog("Project.getEventSum - Project [\(self.slug)] ProjectIssues [\(self.issues?.count ?? 0)] EventSum [\(totalEvents)]")
        return totalEvents
    }

    mutating func updateIssues(newIssues: [Issue]){
        self.issues = newIssues
        self.warnNewIssuesOrEventCount()
    }

    func warnNewIssuesOrEventCount(){
        NSLog("WarnNewIssuesOrCount...")
        let lastRun = Date().addingTimeInterval(Config.LOOP_CYCLE_SECONDS * -1)
        for issue in issues!{
            let diff = issue.lastSeen.timeIntervalSince(lastRun)
            if diff > 0 {
                var notificationData: [String: Any]
                    notificationData = [
                        "type": issue.firstSeen == issue.lastSeen ? NotificationHandler.NEW_ISSUE: NotificationHandler.NEW_EVENT_COUNT,
                        "issue": issue]
                NotificationCenter.default.post(name: Notification.Name(NotificationHandler.NotificationSig), object: nil, userInfo: notificationData)
            }
        }
    }
}
