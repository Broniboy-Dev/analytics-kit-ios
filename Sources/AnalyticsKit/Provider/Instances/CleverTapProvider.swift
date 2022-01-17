//
//  CleverTapProvider.swift
//  
//
//  Created by Johnnie Walker on 19.08.2021.
//

import Foundation
import CleverTapSDK
import CoreLocation
import UserNotifications

class CleverTapProvider: NSObject, ProviderProtocol {
    // MARK: - Properties
    
    private var accountId: String? = nil
    private var accountToken: String? = nil
    private var isDeviceNetworkInfoReportingEnable: Bool?
    var type: AnalyticProviderType = .cleverTap
    var pushNotificationCustomExtras: [AnyHashable : Any]?
    
    // MARK: - ProviderProtocol
    
    func register() {
        if let accountId = accountId, let accountToken = accountToken {
            CleverTap.setCredentialsWithAccountID(accountId, andToken: accountToken)
        }
        CleverTap.autoIntegrate()
        CleverTap.sharedInstance()?.enableDeviceNetworkInfoReporting(isDeviceNetworkInfoReportingEnable ?? false)
    }
    
    func updateUserInfo(
        _ id: Any?,
        _ name: String?,
        _ email: String?,
        _ phone: String?,
        _ location: CLLocationCoordinate2D?
    ) {
        var params: [String : Any] = [:]
        if let id = id { params["Identity"] = id}
        if let name = name { params["Name"]  = name  }
        if let email = email { params["Email"] = email }
        if let phone = phone { params["Phone"] = phone }
        CleverTap.sharedInstance()?.onUserLogin(params)
        
        if let location = location { CleverTap.setLocation(location) }
    }

	func setDeviceToken(_ deviceToken: Data) {
        CleverTap.sharedInstance()?.setPushToken(deviceToken)
        CleverTap.sharedInstance()?.setPushNotificationDelegate(self)
    }
    
    func setAccountId(_ id: String) {
        accountId = id
    }
    
    func setAccountToken(_ token: String) {
        accountToken = token
    }
    
    // TODO: Check the operation of requests in the background queue
    // https://app.clubhouse.io/broniboy/story/15970/clevertap-background
    func sendEvent(_ event: String, with params: [String : Any]) {
        CleverTap.sharedInstance()?.recordEvent(event, withProps: params)
    }
    
    func sendEvent(_ event: String) {
        CleverTap.sharedInstance()?.recordEvent(event)
    }
    
    func sendEvent(with params: [AnyHashable : Any], and items: [Any]) {
        CleverTap.sharedInstance()?.recordChargedEvent(withDetails: params, andItems: items)
    }
    
    func handleNotification(
        with response: UNNotificationResponse,
        _ completionHandler: @escaping ([AnyHashable : Any]?) -> Void
    ) {
        CleverTap.sharedInstance()?.handleNotification(withData: response.notification.request.content.userInfo)
        completionHandler(pushNotificationCustomExtras)
    }
    
    func enableDeviceNetworkInfoReporting(_ permission: Bool?) {
        isDeviceNetworkInfoReportingEnable = permission
    }
}

// MARK: - CleverTapPushNotificationDelegate

extension CleverTapProvider: CleverTapPushNotificationDelegate {
    func pushNotificationTapped(withCustomExtras customExtras: [AnyHashable : Any]!) {
        pushNotificationCustomExtras = customExtras
    }
}
