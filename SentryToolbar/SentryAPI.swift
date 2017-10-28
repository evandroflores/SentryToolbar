//
//  SentryAPI.swift
//  SentryToolbar
//
//  Created by Evandro Flores on 07/10/2017.
//  Copyright © 2017 Evandro Flores. All rights reserved.
//

import Foundation
let API_TOKEN = "<TOKEN>"
let authString = "Bearer \(API_TOKEN)"

let API_BASE = "https://sentry.io"
let ORGANIZATION_SLUG = "<org_slug>"
let PROJECT_SLUG = "<prj_slug>"
let ISSUES_ENDPOINT = "/api/0/projects/\(ORGANIZATION_SLUG)/\(PROJECT_SLUG)/issues/"
let QUERY = "is:unresolved"

class SentryAPI {
    func fetch(completion: ((_ result:Int64) -> Void)!) {
        let session = URLSession.shared
        let url = URL(string: "\(API_BASE)\(ISSUES_ENDPOINT)?query=\(QUERY)")
        var request = URLRequest(url: url!)
        request.httpMethod = "GET"
        request.timeoutInterval = 10
        request.addValue(authString, forHTTPHeaderField: "Authorization")
        
        let task = session.dataTask(with: request) { data, response, err in
            if let error = err {
                NSLog("API Error: \(error)")
                NSLog("Token \(authString)")
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
                        NSLog("URL: \(String(describing: url?.absoluteURL))")
                        
                        //httpResponse.allHeaderFields["Link"] // TODO: pagination
                        
                    } catch {
                        NSLog("Error trying to parse Json: \(error))")
                    }
                case 401:
                    NSLog("Unauthorized access for key: \(API_TOKEN)")
                default:
                    NSLog("API Response: %d %@", httpResponse.statusCode, HTTPURLResponse.localizedString(forStatusCode: httpResponse.statusCode))
                }
            }
            completion(totalIssuesCount)
        }
        task.resume()
    }
}

struct Issue : Codable {
    let id: String
    let title: String
    let count: String
}

struct Link : Codable {
    let id: String
    let title: String
    let count: String
}
