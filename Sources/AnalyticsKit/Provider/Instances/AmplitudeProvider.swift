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
    private var trackingSessionEventsPermission: Bool?
    var type: AnalyticProviderType = .amplitude
    var pushNotificationCustomExtras: [AnyHashable : Any]?
    
    // MARK: - ProviderProtocol
    
    func register() {
        if let token = accountToken {
            Amplitude.instance().initializeApiKey(token)
            Amplitude.instance().adSupportBlock = {
                ASIdentifierManager.shared().advertisingIdentifier.uuidString
            }
            
            Amplitude.instance().trackingSessionEvents = trackingSessionEventsPermission ?? false
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
    
    func sendEventRevenue(for provider: ProviderRevenue) {
        if case .amplitude(let info) = provider {
            Amplitude.instance().logRevenueV2(info)
        }
    }
    
    func setTrackingSessionEventsPermission(_ permission: Bool?) {
        self.trackingSessionEventsPermission = permission
    }
}
