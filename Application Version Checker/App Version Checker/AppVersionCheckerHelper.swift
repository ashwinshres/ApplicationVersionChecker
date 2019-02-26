//
//  AppVersionCheckerHelper.swift
//  Hitched App
//
//  Created by Insight Workshop on 2/20/19.
//  Copyright © 2019 Insight Workshop. All rights reserved.
//

import UIKit

enum VersionCheckerDeviceType: String {
    case ios = "1"
    case android = "2"
}

class AppVersionCheckerHelper {
    
    static func setLastOptionalUpdateTime(timeInterval: TimeInterval?) {
        guard let timeInterval = timeInterval else { return }
        let data = NSKeyedArchiver.archivedData(withRootObject: timeInterval)
        UserDefaults.standard.setValue(data, forKey: AppVersionCheckConstants.UserDefaultKeys.lastUpdateDialogTime)
    }
    
    static func getLastOptionalUpdateTime() -> TimeInterval? {
        guard let data = UserDefaults.standard.value(forKey: AppVersionCheckConstants.UserDefaultKeys.lastUpdateDialogTime) else { return nil }
        return NSKeyedUnarchiver.unarchiveObject(with: (data as! NSData) as Data) as? TimeInterval
    }
    
    static func getTimeInterval(toDate: Date = Date()) -> TimeInterval? {
        return toDate.timeIntervalSince1970
    }
    
    static func getAppWindow() -> UIWindow? {
        return AppVersionCheckerHelper.getAppDelegate().window
    }
    
    static func getAppDelegate() -> AppDelegate {
        return (UIApplication.shared.delegate as! AppDelegate)
    }
    
    static func openUrl(string: String?, fromVC: UIViewController) {
        let errorMessage = "Can not open the url"
        guard let urlString = string,
            let callUrl = URL(string: urlString) else {
                fromVC.showVersionAlertWithOkHandler(message: errorMessage) {}
                return
        }
        AppVersionCheckerHelper.openUrl(url: callUrl, errorMessage: errorMessage, fromController: fromVC)
    }
    
    static func openUrl(url:URL, errorMessage: String, fromController: UIViewController) {
        if UIApplication.shared.canOpenURL(url) {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(url)
            }
        } else {
            fromController.showVersionAlertWithOkHandler(message: errorMessage) {}
        }
    }
    
    static func getAppName() -> String {
        return Bundle.main.infoDictionary?["CFBundleName"] as? String ?? "App Version Check"
    }
    
    static func getAppVersion() -> String {
        return Bundle.main.infoDictionary?["CFBundleShortVersionString"] as! String
    }
    
}
