//
//  AppVersionCheck.swift
//  Hitched App
//
//  Created by Insight Workshop on 2/19/19.
//  Copyright © 2019 Insight Workshop. All rights reserved.
//

import Foundation

class AppVersionCheck: NSObject, Codable {
    
    var appVersion: String  = "1.0"
    var deviceType: String = "1"
    
    override init() {
        super.init()
    }
    
    init(with version: String, and deviceType: String) {
        self.appVersion = version
        self.deviceType = deviceType
    }
    
    private enum CodingKeys: String, CodingKey {
        case appVersion = "app_version"
        case deviceType = "device_type"
    }
    
}

class AppVersionCheckResponse: NSObject, Codable {
    
    var code: Int  = 0
    var message: String = "Error in api call"
    var appStoreLink: String?
    
    override init() {
        super.init()
    }
    
    private enum CodingKeys: String, CodingKey {
        case code = "code"
        case message = "message"
        case appStoreLink = "app_link"
    }
    
}
