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

class StatusMenuController: NSObject {
    @IBOutlet weak var statusMenu: NSMenu!
    let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
    let sentryApi = SentryAPI()
    var lastTotal = Int64(0)
    
    override func awakeFromNib(){
        let icon = NSImage(named: NSImage.Name(rawValue: "ToolbarIcon"))
        icon?.isTemplate = true
        statusItem.image = icon
        statusItem.menu = statusMenu
        statusItem.title = UNCHANGED
        
        sentryApi.fetch(){ (result) -> Void in
            DispatchQueue.main.async {
                self.statusItem.title = self.getTitle(total: result)
            }
        }
        
        
        
    }
    func getTitle(total: Int64) -> String {
        var newTitle = ""
        
        if total == Int64(-1) {
            newTitle = UNCHANGED
        } else if total > lastTotal {
            newTitle = "\(total) \(UP)"
        } else if total < lastTotal {
            newTitle = "\(total) \(DOWN)"
        } else {
            newTitle = "\(total) \(UNCHANGED)"
        }
        lastTotal = total
        
        return newTitle
    }
    
    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
    
    @IBAction func quitClicked(_ sender: NSMenuItem) {
        NSApplication.shared.terminate(self)
    }
}
