//
//  AppVersionChecker.swift
//  Hitched App
//
//  Created by Insight Workshop on 2/19/19.
//  Copyright © 2019 Insight Workshop. All rights reserved.
//

import UIKit

class AppVersionChecker {
    
    static let shared: AppVersionChecker = { return AppVersionChecker() }()
    
    let appUpdateTimeInterval: Double = 24*3600
    var version = "1.0"
    var deviceType = "1"
    var url = ""
    var isShowingAlert = false
    
    func initiate(url: String) {
        self.version =  AppVersionCheckerHelper.getAppVersion()
        self.deviceType = VersionCheckerDeviceType.ios.rawValue
        self.url = url
        
        addApplicationStateObservers()
        
        let appInfo = AppVersionCheck(with: version, and: deviceType)
        checkAppVersion(with: appInfo, url: url)
    }
    
    private func addApplicationStateObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.applicationEnteredForeGround), name: UIApplication.willEnterForegroundNotification, object: nil)
        
    }
    
    @objc private func applicationEnteredForeGround() {
        let appInfo = AppVersionCheck(with: version, and: deviceType)
        checkAppVersion(with: appInfo, url: url)
    }
    
    private func checkAppVersion(with appInfo: AppVersionCheck, url: String) {
        AppVersionCheckerApiHelper.checkVersion(url: url, appVersion: appInfo, responseModal: AppVersionCheckResponse.self ) { (response, error) in
            if let _ = error { }
            else {
                guard let responseModal = response else { return }
                AppVersionChecker.shared.configureAppVersionCheckResponse(responseModal)
            }
        }
    }
    
    private func configureAppVersionCheckResponse(_ response: AppVersionCheckResponse) {
        if response.code == AppVersionCheckConstants.WebServiceCodes.kMandatoryUpdate {
            AppVersionChecker.shared.openAppStore(response)
        } else if response.code == AppVersionCheckConstants.WebServiceCodes.kOptionalUpdate {
            AppVersionChecker.shared.configureOptionalUpdate(with: response)
        }
    }
    
    private func openAppStore(_ response: AppVersionCheckResponse) {
        DispatchQueue.main.async {
            guard let window = AppVersionCheckerHelper.getAppWindow(), let rootVC = window.rootViewController else { return }
            self.isShowingAlert = true
            rootVC.showVersionAlertWithOkHandler(message: response.message, okHandler: {
                self.isShowingAlert = false
                AppVersionCheckerHelper.openUrl(string: response.appStoreLink, fromVC: rootVC)
            })
        }
    }
    
    private  func configureOptionalUpdate(with response: AppVersionCheckResponse) {
        guard let lastUpdateDialogTime = AppVersionCheckerHelper.getLastOptionalUpdateTime() else {
            AppVersionChecker.shared.showOptionalUpdateAlert(with: response)
            return
        }
        
        if let timeStampNow = AppVersionCheckerHelper.getTimeInterval(),
            timeStampNow > lastUpdateDialogTime + (AppVersionChecker.shared.appUpdateTimeInterval){
            AppVersionChecker.shared.showOptionalUpdateAlert(with: response)
        }
    }
    
    private func showOptionalUpdateAlert(with response: AppVersionCheckResponse) {
        guard let window = AppVersionCheckerHelper.getAppWindow(), let rootVC = window.rootViewController else { return }
        rootVC.showVersionAlertWithOkHandler(message: response.message, okText: "Update", cancelText: "Remind Me Later",
                                      okHandler: {
                                        AppVersionChecker.shared.isShowingAlert = false
                                       AppVersionCheckerHelper.openUrl(string: response.appStoreLink, fromVC: rootVC)
        }, cancelHandler: {
            AppVersionChecker.shared.isShowingAlert = false
            AppVersionCheckerHelper.setLastOptionalUpdateTime(timeInterval: AppVersionCheckerHelper.getTimeInterval())
        })
    }
    
}

extension UIViewController {
    
    func showVersionAlertWithOkHandler(message: String = "Something went wrong.\nPlease try again later.",
                                okHandler: @escaping () -> ()) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: AppVersionCheckerHelper.getAppName(), message: message, preferredStyle: .alert)
            let okAction =  UIAlertAction(title: "OK", style: .default){
                handler in
                okHandler()
            }
            alert.addAction(okAction)
            
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func showVersionAlertWithOkHandler(message: String = "Something went wrong.\nPlease try again later.",
                                         okText: String = "Ok", cancelText: String = "Cancel",
                                         okHandler: @escaping () -> (), cancelHandler: @escaping () ->()) {
        
        DispatchQueue.main.async {
            let alert = UIAlertController(title: AppVersionCheckerHelper.getAppName(), message: message, preferredStyle: .alert)
            let okAction =  UIAlertAction(title: okText, style: .default){
                handler in
                okHandler()
            }
            let cancelAction =  UIAlertAction(title: cancelText, style: .default){
                handler in
                cancelHandler()
            }
            alert.addAction(okAction)
            alert.addAction(cancelAction)
            self.present(alert, animated: true, completion: nil)
        }
    }
    
}
