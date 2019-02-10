//
//  ConfigCopyListener.swift
//  SentryToolbar
//
//  Created by Evandro Flores on 10/02/2019.
//  Copyright © 2019 Evandro Flores. All rights reserved.
//

import Foundation

class ConfigCopyListener: NSObject {
    var config: Config

    override init() {
        config = Config.instance
        super.init()

        NotificationCenter.default.addObserver(self, selector: #selector(self.updateConfigCopy(notification:)),
                                               name: Notification.Name(Config.updateConfigSig), object: nil)
    }

    @objc func updateConfigCopy(notification: NSNotification) {
        if let config = notification.object as? Config {
            NSLog("Updating Config")
            self.config = config
        } else {
            NSLog("Not a Config. Nothing to update")
        }
    }
}
