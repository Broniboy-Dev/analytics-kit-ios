//
//  AnalyticsKit.swift
//
//
//  Created by Johnnie Walker on 19.08.2021.
//

import Foundation
import UserNotifications
import CoreLocation

open class AnalyticsKit<Module: AnalyticsModuleProtocol, Event: AnalyticsEventProtocol, Param: AnalyticsParamProtocol> {
    // MARK: - Properties
    
    private var providers: [ProviderProtocol] = []
    
    // MARK: - Initialization
    
    public init() { }
}

// MARK: - AnalyticsProtocol

extension AnalyticsKit: AnalyticsProtocol {
    public func register(_ provider: AnalyticProviderType) {
        let instance = provider.getInstance()
        instance.register()
        providers.append(instance)
    }
    
    public func register(
        _ provider: AnalyticProviderType,
        with settings: [ProviderSettings]
    ) {
        let instance = provider.getInstance()
        applySettings(settings, to: instance)
        instance.register()
        providers.append(instance)
    }
    
    public func applyProvidersSettings(_ settings: [ProviderSettings]) {
        providers.forEach { provider in
            applySettings(settings, to: provider)
        }
    }
    
    public func updateUserInfo(
        with id: Any,
        _ name: String?,
        _ email: String?,
        _ phone: String?,
        _ location: CLLocationCoordinate2D?
    ) {
        providers.forEach { $0.updateUserInfo(id, name, email, phone, location) }
    }
    
    public func sendEvent(_ event: Event) {
        providers.forEach { sendEvent(event, from: nil, by: $0) }
    }
    
    public func sendEvent(
        _ event: Event,
        from module: Module?
    ) {
        providers.forEach { sendEvent(event, from: module, by: $0) }
    }
    
    public func sendEvent(
        _ event: Event,
        with params: [Param : Any]?,
        from module: Module?
    ) {
        providers.forEach { sendEvent(event, with: params, from: module, by: $0) }
    }
    
    public func sendEvent(
        with params: [Param : Any],
        and items: [Any]?
    ) {
        providers.forEach { provider in
            var hashableParams: [AnyHashable : Any] = [:]
            params.forEach { hashableParams[$0.name(for: provider.type)] = $1 }
            provider.sendEvent(with: hashableParams, and: items ?? [])
        }
    }
    
    public func sendTags(_ tags: [String: AnyHashable]) {
        providers.forEach { provider in
            provider.sendTags(tags)
        }
    }
    
    public func sendEventRevenue(with params: [String: Any]) {
        providers.forEach { provider in
            provider.sendEventRevenue(with: params)
        }
    }
    
    public func pressedPushNotification(
        with response: UNNotificationResponse,
        _ completionHandler: @escaping ([(AnalyticProviderType, [AnyHashable : Any])]) -> Void
    ) {
        var completion: [(AnalyticProviderType, [AnyHashable : Any])] = []
        
        providers.forEach { provider in
            provider.handleNotification(with: response) { customExtras in
                guard let customExtras = customExtras else { return }
                completion.append((provider.type, customExtras))
            }
        }
        
        completionHandler(completion)
    }
    
    public func sendEventCrash(with error: Error) {
        providers.forEach { provider in
            provider.sendEventCrash(with: error)
        }
    }
    
    public func sendEventCrash(with message: String) {
        providers.forEach { provider in
            provider.sendEventCrash(with: message)
        }
    }
    
    // TODO: Refactoring
    // Made to preserve the workflow of the BB client, but it seems that it needs some attention / refactoring.
    public func getAndSaveToken() {
        providers.forEach { provider in
            provider.getAndSaveToken()
        }
    }
}

// MARK: - Module functions

private extension AnalyticsKit {
    func applySettings(
        _ settings: [ProviderSettings],
        to provider: ProviderProtocol
    ) {
        settings.forEach { configuration in
            switch configuration {
            case .pushToken(let token):
                provider.setPushToken(deviceToken: token)
            case .accountId(let id):
                provider.setAccountId(id)
            case .accountToken(let token):
                provider.setAccountToken(token)
            case .networkReporting(let value):
                provider.enableDeviceNetworkInfoReporting(value)
            case .fcmTokenCompletion(_, let completion):
                provider.setFCMTokenCompletion(completion)
            }
        }
    }
    
    func sendEvent(
        _ event: Event,
        from module: Module?,
        by provider: ProviderProtocol
    ) {
        let providerType = AnalyticProviderType.getType(from: provider)
        guard event.getPermissionToSentEvent(event, from: module, for: providerType) else { return }
        let eventName = getEventName(event, from: module, by: providerType)
        provider.sendEvent(eventName)
    }
    
    func sendEvent(
        _ event: Event,
        with params: [Param: Any]?,
        from module: Module?,
        by provider: ProviderProtocol
    ) {
        let providerType = AnalyticProviderType.getType(from: provider)
        let eventName = getEventName(event, from: module, by: providerType)
        guard event.getPermissionToSentEvent(event, from: module, for: providerType) else { return }
        
        if let params = params {
            var eventParams: [String: Any] = [:]
            params.forEach { eventParams[$0.name(for: providerType)] = $1 }
            provider.sendEvent(eventName, with: eventParams)
        } else {
            provider.sendEvent(eventName)
        }
    }
    
    func getEventName(
        _ event: Event,
        from module: Module?,
        by provider: AnalyticProviderType
    ) -> String {
        if let module = module {
            return module.name(for: provider) + event.name(for: provider)
        } else {
            return event.name(for: provider)
        }
    }
}
