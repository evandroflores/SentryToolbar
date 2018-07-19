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
    static let loopCycleSeconds = 60.0
    static var configInstance: Config = loadConfig()
    var token: String
    var filters: [String: Filter]
    init() {
        self.filters = [
            "myfilterA": Filter(name: "myfilterA", organizationSlug: "orgA", projectSlug: "projectA"),
            "myfilterB": Filter(name: "myfilterB", organizationSlug: "orgA", projectSlug: "projectB")
        ]
        self.token = "<YOUR TOKEN HERE>"
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
            Config.createDefaultConfig()
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
    static func createDefaultConfig() {
        let encoder = PropertyListEncoder()
        encoder.outputFormat = .xml
        do {
            let config = Config()
            let data = try encoder.encode(config)
            try data.write(to: URL(string: "file://\(Config.configFile)")!)
        } catch {
            NSLog("Config.createDefaultConfig - Fail to write default config: \(Config.configFile): " +
                  "\(error.localizedDescription)")
        }
    }
}
