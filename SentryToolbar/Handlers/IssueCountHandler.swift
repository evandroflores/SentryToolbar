//
//  IssueCountHandler.swift
//  SentryToolbar
//
//  Created by Evandro Flores on 18/03/2018.
//  Copyright © 2018 Evandro Flores. All rights reserved.
//

import Foundation

class IssueCountHandler: NSObject {
    private let concurrentQueue = DispatchQueue(label: "ConcurrentQueue", attributes: .concurrent, target: nil)

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
    var config: Config

    var counter: [String: [String: Int64]] = [:]

    override init() {
        config = Config.instance
        super.init()
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateCount(notification:)),
                                               name: Notification.Name(IssueCountHandler.updateCountSig), object: nil)

        NotificationCenter.default.addObserver(self, selector: #selector(self.updateConfigCopy(notification:)),
                                               name: Notification.Name(Config.updateConfigSig), object: nil)
    }

    @objc func updateCount(notification: NSNotification) {
        NSLog("IssueCountHandler.updateCount")
        concurrentQueue.sync {
            if let filter = notification.object as? Filter {
                NSLog("...in sync for \(filter.name)")
                counter[filter.name] = ["issues": filter.getIssueCount(),
                                        "events": filter.getEventSum()]
                NSLog("COUNTER \(counter)")
                self.updateSum()
            } else {
                NSLog("Not a Filter. Nothing to update")
            }
            self.updateTitle()
        }
    }

    @objc func updateConfigCopy(notification: NSNotification) {
        if let config = notification.object as? Config {
            NSLog("Updating Config")
            self.config = config
        } else {
            NSLog("Not a Config. Nothing to update")
        }
        self.updateTitle()
    }

    func updateSum() {
        var filterEventSum = Int64(0)
        var filterIssueSum = Int64(0)

        for (_, filterCounter) in self.counter {
            NSLog("Updating \(filterCounter)")
            filterIssueSum += filterCounter["issues"]!
            filterEventSum += filterCounter["events"]!
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
        if self.config.showIssueCount {
            newTitle.append(self.currentIssueTotal.description)
        }

        if self.config.showIssueCount && self.config.showEventCount {
            newTitle.append(":")
        }

        if self.config.showEventCount {
            newTitle.append(self.currentEventTotal.description)
        }

        if self.config.showCountTrend {
            newTitle.append(" \(self.getTrend())")
        }

        self.title = newTitle
    }

}
