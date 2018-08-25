//
//  IssueCountHandler.swift
//  SentryToolbar
//
//  Created by Evandro Flores on 18/03/2018.
//  Copyright © 2018 Evandro Flores. All rights reserved.
//

import Foundation

class IssueCountHandler: NSObject {
    static let updateCountSig = "IssueCountHandler.UpdateCount"

    var lastEventTotal = Int64(0)
    var lastIssueTotal = Int64(0)
    var currentEventTotal = Int64(0)
    var currentIssueTotal = Int64(0)

    let trendUp: String = "\u{21E1}"
    let trendDown: String = "\u{21E3}"
    let trendUnchanged: String = "\u{00B7}"
    let trendError: String = "\u{1541}"
    var title: String = ""

    override init() {
        super.init()
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateCount(notification:)),
                                               name: Notification.Name(IssueCountHandler.updateCountSig), object: nil)
    }

    @objc func updateCount(notification: NSNotification) {
        NSLog("IssueCountHandler.updateCount")

        self.updateSum()
        self.updateTitle()
    }

    func updateSum() {
        var filterEventSum = Int64(0)
        var filterIssueSum = Int64(0)

        for (_, filter) in Config.getActiveFilters() {
            filterEventSum += filter.getEventSum()
            filterIssueSum += Int64(filter.issues?.count ?? 0)
        }
        self.lastEventTotal = self.currentEventTotal
        self.currentEventTotal = filterEventSum
        self.lastIssueTotal = self.currentIssueTotal
        self.currentIssueTotal = filterIssueSum
    }

    func getTrend() -> String {
        if self.currentEventTotal > self.lastEventTotal || self.currentIssueTotal > self.lastIssueTotal {
            return self.trendUp
        }

        if self.currentEventTotal < self.lastEventTotal && self.currentIssueTotal < self.lastIssueTotal {
            return self.trendDown
        }

        return self.trendUnchanged
    }

    func updateTitle() {
        var newTitle = ""
        if Config.instance.showIssueCount {
            newTitle.append(self.lastIssueTotal.description)
        }

        if Config.instance.showIssueCount && Config.instance.showEventCount {
            newTitle.append(":")
        }

        if Config.instance.showEventCount {
            newTitle.append(self.lastEventTotal.description)
        }

        if Config.instance.showCountTrend {
            newTitle.append(" \(self.getTrend())")
        }

        self.title = newTitle
    }

}
