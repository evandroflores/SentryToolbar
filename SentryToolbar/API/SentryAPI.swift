//
//  SentryAPI.swift
//  SentryToolbar
//
//  Created by Evandro Flores on 07/10/2017.
//  Copyright © 2017 Evandro Flores. All rights reserved.
//

import Foundation

class SentryAPI {
    func fetchIssues(org: Organization, proj: Project){
        let (url, token) = Config.configInstance.getIssueEndpoint(organization: org, project: proj)

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.timeoutInterval = Config.API_TIMEOUT
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard error == nil else {
                NSLog("API Error URL[\(url)] Token[\(token)] Error[\(String(describing: error))]")
                return
            }

            if let httpResponse = response as? HTTPURLResponse {
                switch httpResponse.statusCode {
                case 200:
                    if data != nil {
                        self.parseIssues(org: org, proj: proj, data: data!)
                    } else {
                        NSLog("Did not receive data for: URL[\(url)] Token[\(token)]")
                        return
                    }

                case 401:
                    NSLog("Unauthorized access for: URL[\(url)] Token[\(token)]")
                default:
                    NSLog("API Response[\(httpResponse.statusCode)] for: URL[\(url)] Token[\(token)] Error[\(HTTPURLResponse.localizedString(forStatusCode: httpResponse.statusCode))]")
                }
            }
        }
        task.resume()
    }

    func parseIssues(org: Organization, proj: Project, data: Data){
        do {
            let decoder = JSONDecoder()
            let issues = try decoder.decode([Issue].self, from: data)
            NSLog("Need to send issues here Issues[\(issues)")

        } catch {
            let rawData = String(data: data, encoding: .utf8)
            NSLog("Error trying to parse Json Org[\(org.slug)] Proj[\(proj.slug)] Error[\(error)] RawData[\(rawData ?? "Empty Data")]")
        }
    }

    func fetch(update: (() -> Void)!) {
        NSLog("SentryAPI.fetch initialized...")
        
        for (_, organization) in Config.configInstance.organizations {
            NSLog("SentryAPI.fetch Organization [\(organization.slug)]")

            for (_, project) in organization.projects {
                NSLog("SentryAPI.fetch Organization [\(organization.slug)] Project [\(project.slug)]")
                let session = URLSession.shared
                let (url, token) = Config.configInstance.getIssueEndpoint(organization: organization, project: project)
        
                var request = URLRequest(url: url)
                request.httpMethod = "GET"
                request.timeoutInterval = Config.API_TIMEOUT
                request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

                let task = session.dataTask(with: request) { data, response, err in
                    if let error = err {
                        NSLog("API Error URL[\(url)] Token[\(token)] Error[\(error)]")
                    }

                    if let httpResponse = response as? HTTPURLResponse {
                        switch httpResponse.statusCode {
                        case 200:
                            do {
                                let decoder = JSONDecoder()
                                let issues = try decoder.decode([Issue].self, from: data!)
                                Config.configInstance.organizations[organization.slug]?.projects[project.slug]?.issues = issues
                                // TODO: this is terrible, I need to find a better way
                                // TODO: API Link pagination
                            } catch {
                                let rawData = String(data: data!, encoding: .utf8)
                                NSLog("Error trying to parse Json URL[\(url)] Token[\(token)] Error[\(error)] RawData[\(rawData ?? "Empty Data")]")
                            }
                        case 401:
                            NSLog("Unauthorized access for: URL[\(url)] Token[\(token)]")
                        default:
                            NSLog("API Response[\(httpResponse.statusCode)] for URL[\(url)] Error[\(HTTPURLResponse.localizedString(forStatusCode: httpResponse.statusCode))]")
                        }
                    }
                    update()
                }
                task.resume()
            }
        }
    }
}
