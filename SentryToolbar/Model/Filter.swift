//
//  Filter.swift
//  SentryToolbar
//
//  Created by Evandro Flores on 18/07/2018.
//  Copyright © 2018 Evandro Flores. All rights reserved.
//

import Foundation

struct Filter: Codable {
    var name: String
    var organizationSlug: String
    var projectSlug: String
    var query: String
    var environment: String
    var statsPeriod: String
    var isActive: Bool = true
    var issues: [Issue]?

    init(name: String, organizationSlug: String, projectSlug: String,
         query: String = "is:unresolved", environment: String = "",
         statsPeriod: String = "30d", isActive: Bool = true) {
        self.name = name
        self.organizationSlug = organizationSlug
        self.projectSlug = projectSlug
        self.query = query
        self.environment = environment
        self.statsPeriod = statsPeriod
        self.issues = []
    }

    enum CodingKeys: String, CodingKey {
        case name
        case organizationSlug
        case projectSlug
        case query
        case environment
        case statsPeriod
        case isActive
    }

    func getIssueCount() -> Int64 {
        if self.issues == nil {
            return Int64(0)
        }
        return Int64(self.issues!.count)
    }

    func getEventSum() -> Int64 {
        var totalEvents = Int64(0)
        if self.issues != nil {
            for issue in self.issues! {
                totalEvents += Int64(issue.count)!
            }
        }
        NSLog("Filter.getEventSum - Filter [\(self.name)] " +
              "Issues [\(self.issues?.count ?? 0)] " +
              "EventSum [\(totalEvents)]")
        return totalEvents
    }

    mutating func updateIssues(newIssues: [Issue]) {
        self.issues = newIssues
        self.sendCountUpdate()
        self.warnNewIssuesOrEventCount()
    }

    func warnNewIssuesOrEventCount() {
        let lastRun = Date().addingTimeInterval(Config.loopCycleSeconds * -2)
        for issue in issues! {
            let diff = issue.lastSeen.timeIntervalSince(lastRun)

            if diff > 0 {
                NotificationCenter.default.post(name: Notification.Name(NotificationHandler.notificationSig),
                                                object: nil, userInfo: issue.toNotification())
            }
        }
    }

    func sendCountUpdate() {
        NotificationCenter.default.post(name: Notification.Name(IssueCountHandler.updateCountSig),
                                        object: self,
                                        userInfo: nil)
    }
}
