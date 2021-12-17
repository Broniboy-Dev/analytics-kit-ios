//
//  AdjustProvider.swift
//  
//
//  Created by Johnnie Walker on 16.12.2021.
//

import Foundation
import Adjust
import CoreLocation

class AdjustProvider: NSObject, ProviderProtocol {
    // MARK: - Properties
    
    private var accountToken: String? = nil
    private var environment: String? = nil
    var type: AnalyticProviderType = .adjust
    
    var pushNotificationCustomExtras: [AnyHashable : Any]?
    
    func register() {
        var adjustConfig: ADJConfig? = nil
        if let accountToken = accountToken, let environment = environment {
            adjustConfig = ADJConfig(appToken: accountToken, environment: environment)
        }
        adjustConfig?.delegate = self
        Adjust.appDidLaunch(adjustConfig)
    }
    
    func updateUserInfo(
        _ id: Any?,
        _ name: String?,
        _ email: String?,
        _ phone: String?,
        _ location: CLLocationCoordinate2D?
    ) {
        if let id = id as? String {
            Adjust.addSessionCallbackParameter("user_id", value: id)
        } else {
            Adjust.removeSessionCallbackParameter("user_id")
        }
    }
    
    func setAccountToken(_ token: String) {
        self.accountToken = token
    }
    
    func setEnvironment(_ environment: String) {
        self.environment = environment
    }
    
    func sendEvent(_ event: String) {
        guard let adjustEvent = ADJEvent(eventToken: event) else { return }
        Adjust.trackEvent(adjustEvent)
    }
    
    func sendEvent(_ event: String, with params: [String : Any]) {
        guard let adjustEvent = ADJEvent(eventToken: event) else { return }
        for (parameterKey, parameterValue) in params {
            let value: String

            if let string = parameterValue as? String {
                value = string
            } else if let bool = parameterValue as? Bool {
                value = bool ? "true" : "false"
            } else if let int = parameterValue as? Int {
                value = String(int)
            } else {
                continue
            }

            adjustEvent.addCallbackParameter(parameterKey, value: value)
        }
        
        Adjust.trackEvent(adjustEvent)
    }
    
    func sendEventOrderCreated(
        _ event: String,
        revenue: Double? = nil,
        transactionId: String? = nil
    ) {
        guard let adjustEvent = ADJEvent(eventToken: event) else { return }

        // TODO: Refactoring
        // RUB - hardcode
        if let revenue = revenue {
            adjustEvent.setRevenue(revenue, currency: "RUB")
        }

        if let transactionId = transactionId {
            adjustEvent.setTransactionId(transactionId)
        }

        Adjust.trackEvent(adjustEvent)
    }
}

extension AdjustProvider: AdjustDelegate {
    // TODO: Refactoring
    func adjustDeeplinkResponse(_ deeplink: URL?) -> Bool {
        true
    }
}
