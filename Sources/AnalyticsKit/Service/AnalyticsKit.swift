//
//  AnalyticsKit.swift
//
//
//  Created by Johnnie Walker on 19.08.2021.
//

import Foundation
import UserNotifications

open class AnalyticsKit<Module: AnalyticsModuleProtocol, Event: AnalyticsEventProtocol, Param: AnalyticsParamProtocol> {
    
    // MARK: - Properties
    
    private var providers: [ProviderProtocol] = []
    
    // MARK: - Initialization
    
    public init() { }
}

// MARK: - AnalyticsProtocol

extension AnalyticsKit: AnalyticsProtocol {
    
    public func register(_ provider: ProviderImage) {
        let instance = provider.getInstance()
        instance.register()
        providers.append(instance)
    }
    
    public func register(_ provider: ProviderImage, with settings: [ProviderSettings]) {
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
    
    public func updateUserInfo(with id: Any, _ name: String?, _ email: String?, _ phone: String?) {
        providers.forEach { $0.updateUserInfo(id, name, email, phone) }
    }
    
    public func sendEvent(_ event: Event) {
        providers.forEach { sendEvent(event, from: nil, by: $0) }
    }
    
    public func sendEvent(_ event: Event, from module: Module?) {
        providers.forEach { sendEvent(event, from: module, by: $0) }
    }
    
    public func sendEvent(_ event: Event, with params: [Param : Any]?, from module: Module?) {
        providers.forEach { sendEvent(event, with: params, from: module, by: $0) }
    }
    
    public func sendEvent(with params: [Param : Any], and items: [Any]?) {
        providers.forEach { provider in
            var hashableParams: [AnyHashable : Any] = [:]
            params.forEach { hashableParams[$0.name(for: provider.providerImage)] = $1 }
            provider.sendEvent(with: hashableParams, and: items ?? [])
        }
    }
    
    public func pressedPushNotification(with response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping ([(ProviderImage, [AnyHashable : Any])]) -> Void) {
        
        var completion: [(ProviderImage, [AnyHashable : Any])] = []
        
        providers.forEach { provider in
            provider.handleNotification(with: response) { customExtras in
                guard let customExtras = customExtras else { return }
                completion.append((provider.providerImage, customExtras))
            }
        }
        
        completionHandler(completion)
    }
}

// MARK: - Module functions

private extension AnalyticsKit {
    
    func applySettings(_ settings: [ProviderSettings], to provider: ProviderProtocol) {
        settings.forEach { configuration in
            switch configuration {
            case .pushToken(let token):
                provider.setPushToken(deviceToken: token)
            case .accountId(let id):
                provider.setAccountId(id)
            case .accountToken(let token):
                provider.setAccountToken(token)
            }
        }
    }
    
    func sendEvent(_ event: Event, from module: Module?, by provider: ProviderProtocol) {
        let providerImage = ProviderImage.getImage(from: provider)
        guard event.getPermissionToSentEvent(event, from: module, for: providerImage) else { return }
        let eventName = getEventName(event, from: module, by: providerImage)
        provider.sendEvent(eventName)
    }
    
    func sendEvent(_ event: Event, with params: [Param: Any]?, from module: Module?, by provider: ProviderProtocol) {
        let providerImage = ProviderImage.getImage(from: provider)
        let eventName = getEventName(event, from: module, by: providerImage)
        guard event.getPermissionToSentEvent(event, from: module, for: providerImage) else { return }
        
        if let params = params {
            var eventParams: [String: Any] = [:]
            params.forEach { eventParams[$0.name(for: providerImage)] = $1 }
            provider.sendEvent(eventName, with: eventParams)
        } else {
            provider.sendEvent(eventName)
        }
    }
    
    func getEventName(_ event: Event, from module: Module?, by provider: ProviderImage) -> String {
        if let module = module {
            return module.name(for: provider) + event.name(for: provider)
        } else {
            return event.name(for: provider)
        }
    }
}
