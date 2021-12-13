//
//  AmplitudeProvider.swift
//  
//
//  Created by Johnnie Walker on 10.12.2021.
//

import AdSupport
import Foundation
import Amplitude
import CoreLocation
import UserNotifications

class AmplitudeProvider: ProviderProtocol {
    // MARK: - Properties
    
    private var accountToken: String? = nil
    var type: AnalyticProviderType = .amplitude
    var pushNotificationCustomExtras: [AnyHashable : Any]?
    
    func register() {
        if let token = accountToken {
            Amplitude.instance().initializeApiKey(token)
            Amplitude.instance().adSupportBlock = {
                ASIdentifierManager.shared().advertisingIdentifier.uuidString
            }
        }
    }
    
    func updateUserInfo(
        _ id: Any,
        _ name: String?,
        _ email: String?,
        _ phone: String?,
        _ location: CLLocationCoordinate2D?
    ) {
        // TODO: Refactoring
        // Write full implementation
        if let id = id as? String {
            Amplitude.instance().setUserId(id)
        }
    }
    
    func setPushToken(deviceToken: Data) {
        
    }
    
    func setAccountId(_ id: String) {
        
    }
    
    func setAccountToken(_ token: String) {
        accountToken = token
    }
    
    func setFCMTokenCompletion(_ completion: @escaping (String) -> Void) {
        
    }
    
    func sendEvent(_ event: String, with params: [String: Any]) {
        Amplitude.instance().logEvent(event, withEventProperties: params)
    }
    
    func sendEvent(_ event: String) {
        Amplitude.instance().logEvent(event, withEventProperties: nil)
    }
    
    func sendEvent(with params: [AnyHashable : Any], and items: [Any]) {
        
    }
    
    func sendTags(_ tags: [String: AnyHashable]) {
        Amplitude.instance().setUserProperties(tags)
    }
    
    func sendEventRevenue(with params: [String: Any]) {
        let revenue = AMPRevenue()
        // TODO: Refactoring
        // 😅😅😅😅😅😅😅
        if let quantity = params["Quantity"] as? Int {
            revenue.setQuantity(quantity)
        }
        
        if let type = params["RevenueType"] as? String {
            revenue.setRevenueType(type)
        }
        
        if let price = params["Price"] as? NSNumber {
            revenue.setPrice(price)
        }
        
        Amplitude.instance().logRevenueV2(revenue)
    }
    
    func handleNotification(with response: UNNotificationResponse, _ completionHandler: @escaping ([AnyHashable : Any]?) -> Void) {
        
    }
    
    func enableDeviceNetworkInfoReporting(_ value: Bool) {
        
    }
    
    func sendEventCrash(with error: Error) {
        
    }
    
    func sendEventCrash(with message: String) {
        
    }
    
    func getAndSaveToken() {
        
    }
}
