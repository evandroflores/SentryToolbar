//
//  SentryAPI.swift
//  SentryToolbar
//
//  Created by Evandro Flores on 07/10/2017.
//  Copyright © 2017 Evandro Flores. All rights reserved.
//

import Foundation

class SentryAPI {
    let conf = Config.configInstance
    func fetch(update: (() -> Void)!) {
        NSLog("SentryAPI.fetch initialized...")
        
        for organization in conf.organizations {
            NSLog("SentryAPI.fetch Organization [\(organization.slug)]")

            for var project in organization.projects {
                NSLog("SentryAPI.fetch Organization [\(organization.slug)] Project [\(project.slug)]")
                let session = URLSession.shared
                let (url, token) = conf.getIssueEndpoint(organization: organization, project: project)
        
                var request = URLRequest(url: url)
                request.httpMethod = "GET"
                request.timeoutInterval = 10
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
                                project.issues = issues
                                // TODO: API Link pagination
                            } catch {
                                NSLog("Error trying to parse Json URL[\(url)] Token[\(token)] Error[\(error)]")
                                let rawData = String(data: data!, encoding: .utf8)
                                NSLog("DATA: \(rawData ?? "Empty Data")")
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
