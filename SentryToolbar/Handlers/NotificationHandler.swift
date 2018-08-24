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
    static let notificationSig = "NotificationSig.showNotification"
    static let newEventCountLabel = "New Issue Event"
    static let newIssueLabel = "New Issue"

    override init() {
        super.init()
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.showNotification(notification:)),
                                               name: Notification.Name(NotificationHandler.notificationSig),
                                               object: nil)
    }

    @objc func showNotification(notification: NSNotification) {
        let issue = notification.userInfo?["issue"] as? Issue
        let notificationType = notification.userInfo?["type"] as? String

        if notificationType == NotificationHandler.newIssueLabel &&
            !Config.configInstance.notifyNewIssue {
            return
        }

        if notificationType == NotificationHandler.newEventCountLabel &&
            !Config.configInstance.notifyNewCount {
            return
        }

        let userNotification = NSUserNotification()
        userNotification.title = notificationType ?? NotificationHandler.newEventCountLabel
        userNotification.subtitle = issue?.title ?? "Issue"
        userNotification.informativeText = "\(issue?.count ?? "-") " +
                                           "Events \( String(describing: issue!.userCount) ) Users"
        userNotification.soundName = NSUserNotificationDefaultSoundName
        userNotification.hasActionButton = false
        userNotification.userInfo = ["permalink": issue?.permalink ?? "https://sentry.io"]

        NSUserNotificationCenter.default.delegate = self
        NSUserNotificationCenter.default.deliver(userNotification)
    }

    public func userNotificationCenter(_ center: NSUserNotificationCenter,
                                       didActivate notification: NSUserNotification) {
        let permalink = notification.userInfo!["permalink"]

        let url = URL(string: (permalink as? String)!)
        NSWorkspace.shared.open(url!)
    }

    // Overwriting setupUserNotificationCenter forcing to show messages when active
    private func setupUserNotificationCenter() {
        let notificationCenter = NSUserNotificationCenter.default
        notificationCenter.delegate = self
    }

    // Overwriting userNotificationCenter forcing to show messages when ative
    public func userNotificationCenter(_ center: NSUserNotificationCenter,
                                       shouldPresent notification: NSUserNotification) -> Bool {
        return true
    }
}
