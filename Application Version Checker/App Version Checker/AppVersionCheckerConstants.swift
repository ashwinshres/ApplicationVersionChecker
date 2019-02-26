//
//  AppVersionCheckerConstants.swift
//  Hitched App
//
//  Created by Insight Workshop on 2/20/19.
//  Copyright © 2019 Insight Workshop. All rights reserved.
//

import Foundation

struct AppVersionCheckConstants {
    
    struct UserDefaultKeys {
        static let lastUpdateDialogTime = "LastUpdateDialogTime"
    }
    
    struct WebServiceCodes {
        static let kSuccessCode     = 1
        static let kErrorCode       = 0
        static let kMandatoryUpdate = 4
        static let kOptionalUpdate  = 5
    }
    
}
