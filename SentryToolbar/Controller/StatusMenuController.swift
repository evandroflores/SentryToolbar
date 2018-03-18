//
//  StatusMenuController.swift
//  SentryToolbar
//
//  Created by Evandro Flores on 07/10/2017.
//  Copyright © 2017 Evandro Flores. All rights reserved.
//

import Cocoa

let UP = "\u{21E1}"
let DOWN = "\u{21E3}"
let UNCHANGED = "\u{00B7}"
let ERR = "\u{1541}"

class StatusMenuController: NSObject {
    @IBOutlet weak var statusMenu: NSMenu!
    let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
    var lastTotal = Int64(0)
    
    override func awakeFromNib(){
        let icon = NSImage(named: NSImage.Name(rawValue: "ToolbarIcon"))
        icon?.isTemplate = true
        statusItem.image = icon
        statusItem.menu = statusMenu
        statusItem.title = UNCHANGED

        let issueCountHandler = IssueCountHandler()

        issueCountHandler.onData.subscribe(with: self) { (total) in
            self.updateTotal(total)
        }
    }
    
    func updateTotal(total: Int64) {
        var newTitle = ""

        if total == Int64(-1) {
            newTitle = ERR
        } else if total > lastTotal {
            newTitle = "\(total) \(UP)"
        } else if total < lastTotal {
            newTitle = "\(total) \(DOWN)"
        } else {
            newTitle = "\(total) \(UNCHANGED)"
        }
        self.lastTotal = total
        
        self.statusItem.title = newTitle
    }
    
    func applicationWillTerminate(_ aNotification: Notification) {}
    
    @IBAction func quitClicked(_ sender: NSMenuItem) {
        NSApplication.shared.terminate(self)
    }
}
