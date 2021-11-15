//
//  CleverTapProvider.swift
//  
//
//  Created by Johnnie Walker on 19.08.2021.
//

import Foundation
import CleverTapSDK

class CleverTapProvider: NSObject, ProviderProtocol {
    
    // MARK: - Properties
    
    private var accountId: String? = nil
    private var accountToken: String? = nil
    
    var providerImage: ProviderImage = .cleverTap
    
    var pushNotificationCustomExtras: [AnyHashable : Any]?
    
    // MARK: - Module functions
    
    func register() {
        if let accountId = accountId, let accountToken = accountToken {
            CleverTap.setCredentialsWithAccountID(accountId, andToken: accountToken)
        }
        CleverTap.setDebugLevel(CleverTapLogLevel.debug.rawValue)
        CleverTap.autoIntegrate()
    }
    
    func updateUserInfo(
        _ id: Any,
        _ name: String?,
        _ email: String?,
        _ phone: String?,
        _ location: CLLocationCoordinate2D?
    ) {
        var params: [String : Any] = [:]
        params["Identity"] = id
        if let name  = name  { params["Name"]  = name  }
        if let email = email { params["Email"] = email }
        if let phone = phone { params["Phone"] = phone }
        CleverTap.sharedInstance()?.onUserLogin(params)
        
        if let location = location { CleverTap.setLocation(location) }
    }

	func setPushToken(deviceToken: Data) {
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
    
    func handleNotification(with response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping ([AnyHashable : Any]?) -> Void) {
        CleverTap.sharedInstance()?.handleNotification(withData: response.notification.request.content.userInfo)
        completionHandler(pushNotificationCustomExtras)
    }
    
    func enableDeviceNetworkInfoReporting(_ value: Bool) {
        CleverTap.sharedInstance()?.enableDeviceNetworkInfoReporting(value)
    }
}

// MARK: - CleverTapPushNotificationDelegate

extension CleverTapProvider: CleverTapPushNotificationDelegate {
    
    func pushNotificationTapped(withCustomExtras customExtras: [AnyHashable : Any]!) {
        pushNotificationCustomExtras = customExtras
    }
}
