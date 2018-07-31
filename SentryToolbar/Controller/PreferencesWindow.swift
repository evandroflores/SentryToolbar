//
//  PreferencesWindow.swift
//  SentryToolbar
//
//  Created by Evandro Flores on 29/03/2018.
//  Copyright © 2018 Evandro Flores. All rights reserved.
//

import Cocoa

class PreferencesWindow: NSWindowController {

    override func showWindow(_ sender: Any?) {
        super.showWindow(sender)
        self.window?.center()
        self.window?.makeKeyAndOrderFront(nil)
        NSApp.activate(ignoringOtherApps: true)
        coverNonBeta()

    }

    func coverNonBeta() {
        if !Config.configInstance.betaMode {
            let nonBetaText = NSTextField(frame: NSRect(x: 20, y: 20, width: 440, height: 197))

            nonBetaText.textColor = NSColor.red
            nonBetaText.stringValue = """
            For now, to change the preferences, edit the file:

            ~/Library/Containers/br.com.eof.SentryToolbar/Data/.SentryToolbar.plist
            """
            self.window?.contentView?.addSubview(nonBetaText)
        }
    }
}
