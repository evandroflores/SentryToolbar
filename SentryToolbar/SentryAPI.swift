//
//  SentryAPI.swift
//  SentryToolbar
//
//  Created by Evandro Flores on 07/10/2017.
//  Copyright © 2017 Evandro Flores. All rights reserved.
//

import Foundation

class SentryAPI {
    let conf = Config.loadCongig()
    func fetch(completion: ((_ result:Int64) -> Void)!) {
        NSLog("SentryAPI.fetch initialized...")
        
        let session = URLSession.shared
        let url = "\(Config.SENTRY_API_BASE)\(String(format: Config.SENTRY_PROJECT_ISSUES_ENDPOINT, conf.organizations[0].slug, conf.organizations[0].projects[0].slug))\(conf.organizations[0].projects[0].getQuery())"
        var request = URLRequest(url: URL(string:url)!)
        request.httpMethod = "GET"
        request.timeoutInterval = 10
        request.addValue("Bearer \(conf.organizations[0].token)", forHTTPHeaderField: "Authorization")
        
        let task = session.dataTask(with: request) { data, response, err in
            if let error = err {
                NSLog("API Error URL[\(url)] Token[\(self.conf.organizations[0].token)] :\(error)")
            }
            var totalIssuesCount = Int64(-1)
            
            if let httpResponse = response as? HTTPURLResponse {
                switch httpResponse.statusCode {
                case 200:
                    do {
                        let decoder = JSONDecoder()
                        let issues = try decoder.decode([Issue].self, from: data!)
                        NSLog(String(describing: issues))
                        NSLog(String(issues.count))
                        
                        for issue in issues {
                            NSLog("\(issue.title) -> \(issue.count)")
                            totalIssuesCount += Int64(issue.count)!
                        }
                        NSLog("Total issues ocurrences \(totalIssuesCount)")
                        // TODO: API Link pagination
                    } catch {
                        NSLog("Error trying to parse Json URL[\(url)] Token[\(self.conf.organizations[0].token)] :\(error)")
                        let rawData = String(data: data!, encoding: .utf8)
                        NSLog("DATA: \(rawData ?? "Empty Data")")
                    }
                case 401:
                    NSLog("Unauthorized access for key: \(self.conf.organizations[0].token)")
                default:
                    NSLog("API Response: %d %@ for url \(url)", httpResponse.statusCode, HTTPURLResponse.localizedString(forStatusCode: httpResponse.statusCode))
                }
            }
            completion(totalIssuesCount)
        }
        task.resume()
    }
}
