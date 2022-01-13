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
    private let utilityQueue = DispatchQueue.global(qos: .utility)
    
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
        _ id: Any?,
        _ name: String?,
        _ email: String?,
        _ phone: String?,
        _ location: CLLocationCoordinate2D?
    ) {
        utilityQueue.sync {
            providers.forEach { $0.updateUserInfo(id, name, email, phone, location) }
        }
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
        utilityQueue.sync {
            providers.forEach { provider in
                var hashableParams: [AnyHashable : Any] = [:]
                params.forEach { hashableParams[$0.name(for: provider.type)] = $1 }
                provider.sendEvent(with: hashableParams, and: items ?? [])
            }
        }
    }
    
    public func sendTags(_ tags: [String: AnyHashable]) {
        utilityQueue.sync {
            providers.forEach { $0.sendTags(tags) }
        }
    }
    
    public func sendEventRevenue(with params: [String: Any]) {
        utilityQueue.sync {
            providers.forEach { $0.sendEventRevenue(with: params) }
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
        providers.forEach { $0.sendEventCrash(with: error) }
    }
    
    public func sendEventCrash(with message: String) {
        providers.forEach { $0.sendEventCrash(with: message) }
    }
    
    public func getAndSaveToken() {
        providers.forEach { $0.getAndSaveToken() }
    }
    
    public func sendEventOrderCreated(_ event: String, revenue: Double?, transactionId: String?) {
        providers.forEach { $0.sendEventOrderCreated(event, revenue: revenue, transactionId: transactionId) }
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
                
            case .environment(let environment):
                provider.setEnvironment(environment)
                
            case .networkReporting(let parmission):
                provider.enableDeviceNetworkInfoReporting(parmission)
                
            case .fcmTokenCompletion(_, let completion):
                provider.setFCMTokenCompletion(completion)
            }
        }
    }
    
    func sendEvent(
        _ event: Event,
        with params: [Param: Any]? = nil,
        from module: Module? = nil,
        by provider: ProviderProtocol
    ) {
        let providerType = AnalyticProviderType.getType(from: provider)
        
        var eventName: String {
            if let module = module {
                return module.name(for: providerType) + event.name(for: providerType)
            } else {
                return event.name(for: providerType)
            }
        }
        
        guard event.getPermissionToSentEvent(event, from: module, for: providerType) else { return }
        
        utilityQueue.sync {
            if let params = params {
                var eventParams: [String: Any] = [:]
                params.forEach { eventParams[$0.name(for: providerType)] = $1 }
                provider.sendEvent(eventName, with: eventParams)
            } else {
                provider.sendEvent(eventName)
            }
        }
    }
}
