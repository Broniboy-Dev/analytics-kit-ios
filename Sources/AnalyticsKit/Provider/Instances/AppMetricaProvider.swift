//
//  AppMetricaProvider.swift
//  AnalyticsKit
//
//  Created by Johnnie Walker on 17.03.2022.
//

import Foundation
import YandexMobileMetrica
import CoreLocation

class AppMetricaProvider: ProviderProtocol {
    // MARK: - Properties
    
    var type: AnalyticProviderType = .appMetrica
    private var accountToken: String? = nil
    var pushNotificationCustomExtras: [AnyHashable: Any]?
    
    // MARK: - ProviderProtocol
    
    func register() {
        guard
            let accountToken = accountToken,
            let configuration = YMMYandexMetricaConfiguration(apiKey: accountToken)
        else {
            NSLog("[AnalyticsKit/AppMetrica] Missing required parameters for registration")
            return
        }
        YMMYandexMetrica.activate(with: configuration)
    }
    
    func updateUserInfo(
        _ id: Any?,
        _ name: String?,
        _ email: String?,
        _ phone: String?,
        _ location: CLLocationCoordinate2D?
    ) {
        if let id = id as? String {
            let profile = YMMMutableUserProfile()
            profile.apply(
                from: [
                    YMMProfileAttribute.name().withValue(name),
                    YMMProfileAttribute.customString("email").withValue(email),
                    YMMProfileAttribute.customString("phone").withValue(phone),
                    YMMProfileAttribute.customString("latitude").withValue(location?.latitude.description),
                    YMMProfileAttribute.customString("longitude").withValue(location?.longitude.description)
                ]
            )
            YMMYandexMetrica.setUserProfileID(id)
            YMMYandexMetrica.report(profile)
        } else {
            NSLog("[AnalyticsKit/AppMetrica] User info was not transferred - userId must be of type String")
        }
    }
    
    func setAccountToken(_ token: String) {
        self.accountToken = token
    }
    
    func sendEvent(_ event: String, with params: [String: Any]) {
        YMMYandexMetrica.reportEvent(event, parameters: params)
    }
    
    func sendEvent(_ event: String) {
        YMMYandexMetrica.reportEvent(event)
    }
    
    func sendEventRevenue(for provider: ProviderRevenue) {
        if case .appMetrica(let info) = provider {
            YMMYandexMetrica.reportRevenue(info)
        }
    }
}
