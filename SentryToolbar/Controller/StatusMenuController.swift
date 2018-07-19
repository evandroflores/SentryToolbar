//
//  StatusMenuController.swift
//  SentryToolbar
//
//  Created by Evandro Flores on 07/10/2017.
//  Copyright © 2017 Evandro Flores. All rights reserved.
//

import Cocoa

class StatusMenuController: NSObject {
    @IBOutlet weak var statusMenu: NSMenu!
    let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
    var preferencesWindow: PreferencesWindow!
    let issueCountHandler = IssueCountHandler()

    override func awakeFromNib() {
        preferencesWindow = PreferencesWindow(windowNibName: NSNib.Name(rawValue: "PreferencesWindow"))
        let icon = NSImage(named: NSImage.Name(rawValue: "ToolbarIcon"))
        icon?.isTemplate = true
        statusItem.image = icon
        statusItem.menu = statusMenu
        statusItem.title = ""

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.updateTitle(notification:)),
                                               name: Notification.Name(IssueCountHandler.updateCountSig),
                                               object: nil)
    }
    @objc func updateTitle(notification: NSNotification) {
        DispatchQueue.main.async {
            self.statusItem.title = self.issueCountHandler.title
        }
    }
    func applicationWillTerminate(_ aNotification: Notification) {}
    @IBAction func preferencesClicked(_ sender: NSMenuItem) {
        NSLog("Prefs clicked")
        preferencesWindow.showWindow(nil)
    }
    @IBAction func quitClicked(_ sender: NSMenuItem) {
        NSApplication.shared.terminate(self)
    }
}
