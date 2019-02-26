//
//  AppVersionCheckerApiHelper.swift
//  Hitched App
//
//  Created by Insight Workshop on 2/21/19.
//  Copyright © 2019 Insight Workshop. All rights reserved.
//

import Foundation

class AppVersionCheckerApiHelper {
    
    static func checkVersion<T: Codable, U: Codable>(url: String, appVersion: T,responseModal: U.Type, completion: @escaping (U?, String?) -> Void) {
       
        let versionCheckerPoint: String = url
        guard let versionCheckerURL = URL(string: versionCheckerPoint) else {
            completion(nil,"Error: cannot create URL")
            return
        }
        var versionCheckerUrlRequest = URLRequest(url: versionCheckerURL)
        versionCheckerUrlRequest.httpMethod = "POST"
        versionCheckerUrlRequest.setValue("Application/json", forHTTPHeaderField: "Content-Type")
        let jsonBody: Data
        do {
            let encoder = JSONEncoder()
            jsonBody = try encoder.encode(appVersion)
            versionCheckerUrlRequest.httpBody = jsonBody
        } catch {
            completion(nil,"Error: cannot create JSON")
            return
        }
        
        let session = URLSession.shared
        let task = session.dataTask(with: versionCheckerUrlRequest) {
            (data, response, error) in
            guard error == nil else {
                completion(nil,"error calling POST")
                return
            }
            guard let responseData = data else {
                completion(nil,"Error: did not receive data")
                return
            }
            
            do {
                let decorder = JSONDecoder()
                let decodedResult = try decorder.decode(U.self, from: responseData)
                completion(decodedResult,nil)
            } catch  {
                completion(nil,"error parsing response")
                return
            }
        }
        task.resume()
    }
    
}
