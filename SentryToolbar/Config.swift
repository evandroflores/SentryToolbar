//
//  Config.swift
//  SentryToolbar
//
//  Created by Evandro Flores on 28/10/2017.
//  Copyright © 2017 Evandro Flores. All rights reserved.
//

import Foundation

struct Config : Codable {
    // Config will search plist file here
    // ~/Library/Containers/br.com.eof.SentryToolbar/Data/.SentryToolbar.plist
    static let CONFIG_FILE = "\(NSHomeDirectory())/.SentryToolbar.plist"
    static let DEFAULT_API_BASE = "https://sentry.io/api/0/projects/"
    static let DEFAULT_ISSUES_ENDPOINT = "/issues/"

    let sentryApiBase: String
    let sentryIssuesEndpoint: String
    
    let organizations: [Organization]
    
    init(){
        self.sentryApiBase = Config.DEFAULT_API_BASE
        self.sentryIssuesEndpoint = Config.DEFAULT_ISSUES_ENDPOINT
        
        let projects = [Project(slug: "your_project_slug", query: "is:unresolved")]
        self.organizations = [Organization(slug: "your_org_slug", token: "YOUR TOKEN HERE", projects: projects)]
    }
    
    func toDict() -> [String : Any] {
        var dict = [String:Any]()
        let mirror = Mirror(reflecting: self)

        for child in mirror.children {
            if let key = child.label {
                dict[key] = child.value
            }
        }
        return dict
    }
    
    func getSentryApiBase() -> String {
        if !self.sentryApiBase.isEmpty {
            return self.sentryApiBase
        } else {
            return Config.DEFAULT_API_BASE
        }
    }
    
    func getSentryIssueEndPoint() -> String {
        if !self.sentryIssuesEndpoint.isEmpty {
            return self.sentryIssuesEndpoint
        } else {
            return Config.DEFAULT_ISSUES_ENDPOINT
        }
    }
    
    func issueUrl () -> URL {
        return URL(string: "\(self.getSentryApiBase())\(self.getSlugs())\(self.getSentryIssueEndPoint())\(self.organizations[0].projects[0].getQuery())")!
    }
    
    func getSlugs() -> String {
        return "\(self.organizations[0].slug)/\(self.organizations[0].projects[0].slug)"
    }

    static func loadCongig() -> Config{
        NSLog("Loading config \(Config.CONFIG_FILE)...")
        if (!FileManager.default.fileExists(atPath: Config.CONFIG_FILE)){
            NSLog("File \(Config.CONFIG_FILE) does not exists. Ask for creation...")
            Config.createDefaultConfig()
        }
        
        var config: Config
        var data: Data
        do {
            data = try Data(contentsOf: URL(string: "file://\(Config.CONFIG_FILE)")!)
            let decoder = PropertyListDecoder()
            config = try decoder.decode(Config.self, from: data)
        } catch {
            NSLog("Fail to load config: \(error.localizedDescription)")
            config = Config()
        }
        NSLog("\(config.toDict())")
        return config
    }
    
    static func createDefaultConfig(){
        let encoder = PropertyListEncoder()
        encoder.outputFormat = .xml
        do {
            let config = Config()
            let data = try encoder.encode(config)
            try data.write(to: URL(string: "file://\(Config.CONFIG_FILE)")!)
        } catch {
            NSLog("Fail to write default config: \(Config.CONFIG_FILE): \(error.localizedDescription)")
        }
    }
}
