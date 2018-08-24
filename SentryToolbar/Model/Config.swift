//
//  Config.swift
//  SentryToolbar
//
//  Created by Evandro Flores on 28/10/2017.
//  Copyright © 2017 Evandro Flores. All rights reserved.
//

import Foundation

struct Config: Codable {
    // Config will search plist file here
    // ~/Library/Containers/br.com.eof.SentryToolbar/Data/.SentryToolbar.plist
    static let configFile = "\(NSHomeDirectory())/.SentryToolbar.plist"
    static var configInstance: Config = loadConfig()

    static let loopCycleSeconds = 60.0
    var betaMode: Bool
    var showIssueCount: Bool
    var showEventCount: Bool
    var showCountTrend: Bool
    var notifyNewIssue: Bool
    var notifyNewCount: Bool

    var token: String
    var filters: [String: Filter]

    init() {
        self.filters = [
            "myfilterA": Filter(name: "myfilterA", organizationSlug: "orgA", projectSlug: "projectA"),
            "myfilterB": Filter(name: "myfilterB", organizationSlug: "orgA", projectSlug: "projectB")
        ]
        self.token = "<YOUR TOKEN HERE>"
        self.betaMode = false
        self.showIssueCount = false
        self.showEventCount = true
        self.showCountTrend = true
        self.notifyNewIssue = true
        self.notifyNewCount = true
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.filters = try container.decodeIfPresent([String: Filter].self, forKey: .filters) ?? [:]
        self.token = try container.decodeIfPresent(String.self, forKey: .token) ?? "<YOUR TOKEN HERE>"
        self.betaMode = try container.decodeIfPresent(Bool.self, forKey: .betaMode) ?? false
        self.showIssueCount = try container.decodeIfPresent(Bool.self, forKey: .showIssueCount) ?? false
        self.showEventCount = try container.decodeIfPresent(Bool.self, forKey: .showEventCount) ?? true
        self.showCountTrend = try container.decodeIfPresent(Bool.self, forKey: .showCountTrend) ?? true
        self.notifyNewIssue = try container.decodeIfPresent(Bool.self, forKey: .notifyNewIssue) ?? true
        self.notifyNewCount = try container.decodeIfPresent(Bool.self, forKey: .notifyNewCount) ?? true
    }

    func toDict() -> [String: Any] {
        var dict = [String: Any]()
        let mirror = Mirror(reflecting: self)

        for child in mirror.children {
            if let key = child.label {
                dict[key] = child.value
            }
        }
        return dict
    }
    static func loadConfig() -> Config {
        NSLog("Config.loadConfig - File[\(Config.configFile)]...")
        if !FileManager.default.fileExists(atPath: Config.configFile) {
            NSLog("Config.loadConfig - File [\(Config.configFile)] does not exists. Creating a sample...")
            Config.save()
        }

        var config: Config
        var data: Data

        do {
            data = try Data(contentsOf: URL(string: "file://\(Config.configFile)")!)
            let decoder = PropertyListDecoder()
            config = try decoder.decode(Config.self, from: data)
        } catch {
            NSLog("Config.loadConfig - Fail to parse config: \(error.localizedDescription)")
            config = Config()
        }
        NSLog("Config.loadConfig - Success: \(config.toDict())")
        return config
    }

    static func save() {
        let encoder = PropertyListEncoder()
        encoder.outputFormat = .xml
        do {
            let data = try encoder.encode(Config.configInstance)
            try data.write(to: URL(string: "file://\(Config.configFile)")!)
        } catch {
            NSLog("Config.createDefaultConfig - Fail to write default config: \(Config.configFile): " +
                "\(error.localizedDescription)")
        }

    }

    static func getActiveFilters() -> [String: Filter] {
        return Config.configInstance.filters.filter({$0.1.isActive == true})
    }
}
