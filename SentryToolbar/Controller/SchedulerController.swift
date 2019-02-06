//
//  SchedulerConrtoller.swift
//  SentryToolbar
//
//  Created by Evandro Flores on 18/03/2018.
//  Copyright © 2018 Evandro Flores. All rights reserved.
//

import Foundation

class SchedulerController: NSObject {
    var sentryApi: SentryAPI
    var timer: Timer!

    override init() {
        NSLog("SchedulerController.init")
        sentryApi = SentryAPI()
        super.init()
        timer = Timer.scheduledTimer(timeInterval: Config.loopCycleSeconds,
                                     target: self,
                                     selector: #selector(loop),
                                     userInfo: nil,
                                     repeats: true)
    }

    @objc func loop() {
        for (_, filter) in Config.getActiveFilters() {
            NSLog("SchedulerController.loop Filter [\(filter.name)] " +
                  "-> Organization [\(filter.organizationSlug)] " +
                  "Project [\(filter.projectSlug)] " +
                  "Query [\(filter.query)] " +
                  "Env [\(filter.environment)]")

            DispatchQueue.global(qos: DispatchQoS.background.qosClass).async {
                self.sentryApi.fetchIssues(filter: filter)
            }
        }
    }

    func start() {
        timer.fire()
    }

    func updateTotal() {
        NSLog("SchedulerController.update")
    }

    func stop() {
        NSLog("SchedulerController.stop")
        timer.invalidate()
    }
}
