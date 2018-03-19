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

    override init(){
        super.init()
        NotificationCenter.default.addObserver(self, selector: #selector(self.showNotification(notification:)), name: Notification.Name(NotificationHandler.NotificationSig), object: nil)
    }

    @objc func showNotification(notification: NSNotification){
        NSLog("To show notification here...")

        let notification = NSUserNotification()

        notification.title = "New Issue Count"
        notification.subtitle = "Issue title will show here"
        notification.informativeText = "Maybe a bit more of info about the issue"
        notification.soundName = NSUserNotificationDefaultSoundName

        NSUserNotificationCenter.default.delegate = self
        NSUserNotificationCenter.default.deliver(notification)

    }

    private func setupUserNotificationCenter() {
        let nc = NSUserNotificationCenter.default
        nc.delegate = self
    }

    public func userNotificationCenter(_ center: NSUserNotificationCenter, shouldPresent notification: NSUserNotification) -> Bool {
        return true
    }
}
