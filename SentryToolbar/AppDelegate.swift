//
//  AppDelegate.swift
//  SentryToolbar
//
//  Created by Evandro Flores on 06/10/2017.
//  Copyright © 2017 Evandro Flores. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    let scheduler = SchedulerController()
    let notification = NotificationHandler()

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        NSLog("App started.")
        scheduler.start()
    }
    func applicationWillTerminate(_ aNotification: Notification) {
        scheduler.stop()
        NSLog("App Finished.")
    }
}
