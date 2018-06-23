//
//  NotificationHandler.swift
//  SentryToolbar
//
//  Created by Evandro Flores on 19/03/2018.
//  Copyright © 2018 Evandro Flores. All rights reserved.
//

import Foundation
import Cocoa

class NotificationHandler: NSObject, NSUserNotificationCenterDelegate {
    static let NotificationSig = "NotificationSig.showNotification"
    static let NEW_EVENT_COUNT = "New Issue Event"
    static let NEW_ISSUE = "New Issue"

    override init(){
        super.init()
        NotificationCenter.default.addObserver(self, selector: #selector(self.showNotification(notification:)), name: Notification.Name(NotificationHandler.NotificationSig), object: nil)
    }

    @objc func showNotification(notification: NSNotification){
        let issue = notification.userInfo?["issue"] as? Issue
        let notificationType = notification.userInfo?["type"] as? String

        let userNotification = NSUserNotification()
        userNotification.title = notificationType ?? NotificationHandler.NEW_EVENT_COUNT
        userNotification.subtitle = issue?.title ?? "Issue"
        userNotification.informativeText = "\(issue?.count ?? "-") Events \( String(describing: issue!.userCount) ) Users"
        userNotification.soundName = NSUserNotificationDefaultSoundName
        userNotification.hasActionButton = false
        userNotification.userInfo = ["permalink": issue?.permalink ?? "https://sentry.io"]

        NSUserNotificationCenter.default.delegate = self
        NSUserNotificationCenter.default.deliver(userNotification)
    }

    public func userNotificationCenter(_ center: NSUserNotificationCenter, didActivate notification: NSUserNotification) {
        let permalink = notification.userInfo?["permalink"] as! String

        let url = URL(string: permalink)
        NSWorkspace.shared.open(url!)
    }

    // Overwriting setupUserNotificationCenter forcing to show messages when active
    private func setupUserNotificationCenter() {
        let nc = NSUserNotificationCenter.default
        nc.delegate = self
    }

    // Overwriting userNotificationCenter forcing to show messages when ative
    public func userNotificationCenter(_ center: NSUserNotificationCenter, shouldPresent notification: NSUserNotification) -> Bool {
        return true
    }
}
