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

    override init(){
        NSLog("SchedulerController.init")
        conf = Config.configInstance
    }

    func start(){
        for (_, org) in conf.organizations {
            NSLog("SchedulerController.loop Organization [\(org.slug)]")
            for (_, proj) in org.projects {
                NSLog("SchedulerController.loop Organization [\(org.slug)] Project [\(proj.slug)]")
            }
        }
    }

    func stop(){
        NSLog("SchedulerController.stop")
    }
}
