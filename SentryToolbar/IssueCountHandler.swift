//
//  IssueCountHandler.swift
//  SentryToolbar
//
//  Created by Evandro Flores on 18/03/2018.
//  Copyright © 2018 Evandro Flores. All rights reserved.
//

import Foundation
import Signals

class IssueCountHandler {
    let onData = Signal<Int64>()



    func updateCount(){
        var total = Int64(-1)

        for (_, organization) in Config.configInstance.organizations{
            total += organization.getTotalIssues()
        }
        self.onData.fire(total)
    }
}
