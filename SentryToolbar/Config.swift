//
//  Config.swift
//  SentryToolbar
//
//  Created by Evandro Flores on 28/10/2017.
//  Copyright © 2017 Evandro Flores. All rights reserved.
//

import Foundation

struct Config : Codable {
    static let CONFIG_FILE = "\(NSHomeDirectory())/.SentryToolbar.plist"
    static let DEFAULT_API_BASE = "https://sentry.io/api/0/projects/"
    static let DEFAULT_ISSUES_ENDPOINT = "/issues/"

    let sentryToken: String
    let sentryApiBase: String
    let sentryIssuesEndpoint: String
    let organizationSlug: String
    let projectSlug: String
    let query: String
    
    init(){
        self.sentryToken = "YOUR TOKEN HERE"
        self.sentryApiBase = Config.DEFAULT_API_BASE
        self.sentryIssuesEndpoint = Config.DEFAULT_ISSUES_ENDPOINT
        self.organizationSlug = "orgslug"
        self.projectSlug = "prjslug"
        self.query = "is:unresolved"
    }
    
    func issueUrl () -> URL {
        return URL(string: "\(self.getSentryApiBase())\(self.getSlugs())\(self.getSentryIssueEndPoint())\(self.getQuery())")!
    }
    
    func getQuery() -> String {
        if !self.query.isEmpty {
            return "?query=\(self.query)"
        } else {
            return ""
        }
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
    
    func getSlugs() -> String {
        return "\(self.organizationSlug)/\(self.projectSlug)"
    }

    static func loadCongig() -> Config{
        NSLog("Loading config \(Config.CONFIG_FILE)...")
        if (!FileManager.default.fileExists(atPath: Config.CONFIG_FILE)){
            NSLog("File \(Config.CONFIG_FILE) does not exists. Ask for creation...")
            Config.createDefaultConfig()
        }
        
        var settings: Config
        var data: Data
        do {
            data = try Data(contentsOf: URL(string: "file://\(Config.CONFIG_FILE)")!)
            let decoder = PropertyListDecoder()
            settings = try decoder.decode(Config.self, from: data)
        } catch {
            NSLog("Fail to load config: \(error.localizedDescription)")
            settings = Config()
        }
        return settings
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
