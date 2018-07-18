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
    
    static let UpdateCountSig = "IssueCountHandler.UpdateCount"
    let UP = "\u{21E1}"
    let DOWN = "\u{21E3}"
    let UNCHANGED = "\u{00B7}"
    let ERR = "\u{1541}"
    var title = ""

    override init(){
        super.init()
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateCount(notification:)), name: Notification.Name(IssueCountHandler.UpdateCountSig), object: nil)
    }

    @objc func updateCount(notification: NSNotification) {
        NSLog("IssueCountHandler.updateCount")
        var total = Int64(0)

        for (_, filter) in Config.configInstance.filters {
            total += filter.getEventSum()
        }

        updateTitle(total: total)
    }

    func updateTitle(total: Int64) {
        if total > lastTotal {
            title = "\(total) \(UP)"
        } else if total < lastTotal {
            title = "\(total) \(DOWN)"
        } else {
            title = "\(total) \(UNCHANGED)"
        }
        self.lastTotal = total
    }
}


