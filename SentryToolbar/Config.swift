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
    static let SENTRY_API_BASE = "https://sentry.io/api/0"
    static let SENTRY_PROJECT_ISSUES_ENDPOINT = "/projects/%@/%@/issues/"

    static var configInstance: Config = loadConfig()

    let organizations: [Organization]
    
    init(){
        let projects = [Project(slug: "your_project_slug", query: "is:unresolved")]
        self.organizations = [Organization(slug: "your_org_slug", token: "YOUR TOKEN HERE", projects: projects)]
    }

    func getIssueEndpoint(organization: Organization, project: Project) -> (URL, String){
        let url = "\(Config.SENTRY_API_BASE)" +
                  "\(String(format: Config.SENTRY_PROJECT_ISSUES_ENDPOINT, organization.slug, project.slug))" +
                  "\(project.getQuery())"
        return (URL(string:url)!, organization.token)
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

    static func loadConfig() -> Config{
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
