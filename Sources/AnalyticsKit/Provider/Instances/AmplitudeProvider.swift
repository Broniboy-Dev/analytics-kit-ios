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
    
    var type: AnalyticProviderType = .amplitude
    var pushNotificationCustomExtras: [AnyHashable : Any]?
    var logLevel: AnalyticsLogLevel?
    
    private var accountToken: String? = nil
    
    func register() {
        if let token = accountToken {
            Amplitude.instance().initializeApiKey(token)
            Amplitude.instance().adSupportBlock = {
                ASIdentifierManager.shared().advertisingIdentifier.uuidString
            }
            
            switch logLevel {
            case .min, .max:
                // TODO: Write a nominal logger layer
                NSLog("[AnalyticsKit/Amplitude]: Does not support changing the logging level. By default, only critical errors are logged to console.")
            case .none:
                break
            }
        }
    }
    
    func updateUserInfo(
        _ id: Any?,
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
    
    func setAccountToken(_ token: String) {
        accountToken = token
    }
    
    func sendEvent(_ event: String, with params: [String: Any]) {
        Amplitude.instance().logEvent(event, withEventProperties: params)
    }
    
    func sendEvent(_ event: String) {
        Amplitude.instance().logEvent(event, withEventProperties: nil)
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
    
    func setLogLevel(_ logLevel: AnalyticsLogLevel) {
        self.logLevel = logLevel
    }
}
