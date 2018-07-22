//
//  IssueCountHandler.swift
//  SentryToolbar
//
//  Created by Evandro Flores on 18/03/2018.
//  Copyright © 2018 Evandro Flores. All rights reserved.
//

import Foundation

class IssueCountHandler: NSObject {
    var lastTotal = Int64(0)
    static let updateCountSig = "IssueCountHandler.UpdateCount"
    let trendUp = "\u{21E1}"
    let trendDown = "\u{21E3}"
    let trendUnchanged = "\u{00B7}"
    let trendError = "\u{1541}"
    var title = ""

    override init() {
        super.init()
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateCount(notification:)),
                                               name: Notification.Name(IssueCountHandler.updateCountSig), object: nil)
    }

    @objc func updateCount(notification: NSNotification) {
        NSLog("IssueCountHandler.updateCount")
        var total = Int64(0)

        for (_, filter) in Config.getActiveFilters() {
            total += filter.getEventSum()
        }

        updateTitle(total: total)
    }

    func updateTitle(total: Int64) {
        if total > lastTotal {
            title = "\(total) \(trendUp)"
        } else if total < lastTotal {
            title = "\(total) \(trendDown)"
        } else {
            title = "\(total) \(trendUnchanged)"
        }
        self.lastTotal = total
    }
}
