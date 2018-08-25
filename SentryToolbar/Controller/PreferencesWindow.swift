//
//  PreferencesWindow.swift
//  SentryToolbar
//
//  Created by Evandro Flores on 29/03/2018.
//  Copyright © 2018 Evandro Flores. All rights reserved.
//

import Cocoa

class PreferencesWindow: NSWindowController {

    @IBOutlet weak var token: NSTextField!
    @IBOutlet weak var tokenCheckButton: NSButton!
    @IBOutlet weak var showIssueCount: NSButton!
    @IBOutlet weak var showEventCount: NSButton!
    @IBOutlet weak var showCountTrend: NSButton!
    override func showWindow(_ sender: Any?) {
        super.showWindow(sender)
        self.window?.center()
        self.window?.makeKeyAndOrderFront(nil)
        NSApp.activate(ignoringOtherApps: true)
        coverNonBeta()

        self.token.stringValue = Config.instance.token
        self.showIssueCount.state = self.getState(shouldBeOn: Config.instance.showIssueCount)
        self.showEventCount.state = self.getState(shouldBeOn: Config.instance.showEventCount)
        self.showCountTrend.state = self.getState(shouldBeOn: Config.instance.showCountTrend)
    }

    private func getState(shouldBeOn: Bool) -> NSControl.StateValue {
        return shouldBeOn ? NSControl.StateValue.on : NSControl.StateValue.off
    }

    override func windowDidLoad() {
        super.windowDidLoad()

        self.window?.makeFirstResponder(self)
        self.token.focusRingType = NSFocusRingType.none
    }

    func coverNonBeta() {
        if !Config.instance.betaMode {
            let nonBetaText = NSTextField(frame: NSRect(x: 20, y: 20, width: 440, height: 197))

            nonBetaText.textColor = NSColor.red
            nonBetaText.stringValue = """
            For now, to change the preferences, edit the file:

            ~/Library/Containers/br.com.eof.SentryToolbar/Data/.SentryToolbar.plist
            """
        self.window?.contentView?.addSubview(nonBetaText)
        }
    }

    @IBAction func tokenHelpClicked(_ sender: Any) {
        if let url = URL(string: "https://sentry.io/settings/account/api/auth-tokens/"),
            NSWorkspace.shared.open(url) {
        }
    }

    @IBAction func tokenCheckClicked(_ sender: Any) {
        SentryAPI.isTokenValid(token: token.stringValue, withHandler: handleTokenValidation)
    }

    func handleTokenValidation(httpStatus: Int) {
        NSLog("handleTokenValidation \(httpStatus)")
        var statusColor: NSColor

        if httpStatus == 200 {
            statusColor = NSColor(red: 0.161, green: 0.807, blue: 0.260, alpha: 0.75)
        } else {
            statusColor = NSColor(red: 0.998, green: 0.375, blue: 0.347, alpha: 0.75)
        }

        DispatchQueue.main.async {
            self.token.wantsLayer = true
            self.token.layer?.borderWidth = 2.0
            self.token.layer?.cornerRadius = 3.0
            self.token.layer?.borderColor = statusColor.cgColor
        }
    }

    @IBAction func saveClicked(_ sender: Any) {
        Config.instance.token = self.token.stringValue
        Config.instance.showIssueCount = self.showIssueCount.state.rawValue == 1
        Config.instance.showEventCount = self.showEventCount.state.rawValue == 1
        Config.instance.showCountTrend = self.showCountTrend.state.rawValue == 1
        Config.save()
        NotificationCenter.default.post(name: Notification.Name(IssueCountHandler.updateCountSig),
                                        object: nil,
                                        userInfo: nil)
    }

}
