//
//  NotificationHandler.swift
//  SentryToolbar
//
//  Created by Evandro Flores on 19/03/2018.
//  Copyright © 2018 Evandro Flores. All rights reserved.
//

import Foundation

class NotificationHandler: NSObject, NSUserNotificationCenterDelegate {
    static let NotificationSig = "NotificationSig.showNotification"
    static let NEW_COUNT = "New Issue Count"
    static let NEW_ISSUE = "New Issue"

    override init(){
        super.init()
        NotificationCenter.default.addObserver(self, selector: #selector(self.showNotification(notification:)), name: Notification.Name(NotificationHandler.NotificationSig), object: nil)
    }

    @objc func showNotification(notification: NSNotification){
        let issue = notification.userInfo?["issue"] as? Issue
        let notificationType = notification.userInfo?["type"] as? String

        let userNotification = NSUserNotification()
        userNotification.title = notificationType ?? NotificationHandler.NEW_COUNT
        userNotification.subtitle = issue?.title ?? "No title provided"
        userNotification.informativeText = "\(issue?.count ?? "-") Events \( String(describing: issue!.userCount) ) Users"
        userNotification.soundName = NSUserNotificationDefaultSoundName
        userNotification.hasActionButton = false

        NSUserNotificationCenter.default.delegate = self
        NSUserNotificationCenter.default.deliver(userNotification)
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
