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
    var sentryApi: SentryAPI
    var timer: Timer!

    override init(){
        NSLog("SchedulerController.init")
        conf = Config.configInstance
        sentryApi = SentryAPI()
        super.init()
        timer = Timer.scheduledTimer(timeInterval: Config.LOOP_CYCLE_SECONDS, target: self, selector: #selector(loop), userInfo: nil, repeats: true)
    }

    @objc func loop(){
        for (_, org) in conf.organizations {
            NSLog("SchedulerController.loop Organization [\(org.slug)]")
            for (_, proj) in org.projects {
                NSLog("SchedulerController.loop Organization [\(org.slug)] Project [\(proj.slug)]")

                DispatchQueue.global(qos: DispatchQoS.background.qosClass).async {
                    self.sentryApi.fetchIssues(org: org, proj: proj)
                }
            }
        }
    }

    func start(){
        timer.fire()
    }

    func updateTotal(){
        NSLog("SchedulerController.update")
    }

    func stop(){
        NSLog("SchedulerController.stop")
        timer.invalidate()
    }
}
