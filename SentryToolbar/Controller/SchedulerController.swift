//
//  SchedulerConrtoller.swift
//  SentryToolbar
//
//  Created by Evandro Flores on 18/03/2018.
//  Copyright © 2018 Evandro Flores. All rights reserved.
//

import Foundation

class SchedulerController: NSObject {
    var conf: Config
    var orgs:[Organization]

    override init(){
        NSLog("SchedulerController.init")
        conf = Config.configInstance
        orgs = conf.organizations
    }

    func start(){
        for (_, org) in orgs.enumerated() {
            NSLog("SchedulerController.loop.Organization [\(org.slug)]")
        }
    }

    func stop(){
        NSLog("SchedulerController.stop")
    }
}
