//
//  AppDelegate.swift
//  SentryToolbar
//
//  Created by Evandro Flores on 06/10/2017.
//  Copyright © 2017 Evandro Flores. All rights reserved.
//

import Cocoa
import Sentry

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    let scheduler = SchedulerController()
    let notification = NotificationHandler()

    func applicationDidFinishLaunching(_ notification: Notification) {
        NSLog("App started.")

        do {
            Client.shared = try Client(dsn: "https://a5d5a1bff8934498ad851795160e5b9f@sentry.io/1390888")
            try Client.shared?.startCrashHandler()
        } catch let error {
            NSLog("\(error)")
        }
        scheduler.start()
    }
    func applicationWillTerminate(_ notification: Notification) {
        scheduler.stop()
        NSLog("App Finished.")
    }
}
