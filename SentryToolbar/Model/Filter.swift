//
//  Filter.swift
//  SentryToolbar
//
//  Created by Evandro Flores on 18/07/2018.
//  Copyright © 2018 Evandro Flores. All rights reserved.
//

import Foundation

struct Filter : Codable {
    var name: String
    var organizationSlug: String
    var projectSlug: String
    var query: String = "is:unresolved"
    var isActive: Bool = true
    var issues: [Issue]?

    init(name: String, organizationSlug: String, projectSlug: String, query: String = "is:unresolved", isActive: Bool = true){
        self.name = name
        self.organizationSlug = organizationSlug
        self.projectSlug = projectSlug
        self.query = query
        self.issues = []
    }

    func getQuery() -> String {
        if self.query.isEmpty {
            return ""
        } else {
            return "?query=\(self.query)"
        }
    }

    func getEventSum() -> Int64 {
        var totalEvents = Int64(0)
        if self.issues != nil {
            for issue in self.issues! {
                totalEvents += Int64(issue.count)!
            }
        }
        NSLog("Filter.getEventSum - Filter [\(self.name)] Issues [\(self.issues?.count ?? 0)] EventSum [\(totalEvents)]")
        return totalEvents
    }

    mutating func updateIssues(newIssues: [Issue]){
        self.issues = newIssues
        self.warnNewIssuesOrEventCount()
    }

    func warnNewIssuesOrEventCount(){
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
