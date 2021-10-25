//
//  AnalyticsProtocol.swift
//  
//
//  Created by Johnnie Walker on 19.08.2021.
//

import Foundation
import UserNotifications

public protocol AnalyticsProtocol {
    
    associatedtype Module: AnalyticsModuleProtocol
    associatedtype Event: AnalyticsEventProtocol
    associatedtype Param: AnalyticsParamProtocol
    
    /**
     Registers the required analytics provider
     
     ### ⚠️ Important
     You must make sure that the Analytics instance is unique and is not overwritten during the application lifecycle.
     
     If the object is lost after the providers are registered, the `sendEvent` method will have no event dispatch targets.
     
     ### Example
     ```
     struct AnalyticsWrapper<T: AnalyticsProtocol> {
         let service: T
     }
     
     class AnalyticsService {
     
        func activateAnalytics() {
            let analytics = DI.container.resolve(AnalyticsWrapper<ClientAppAnalytics>.self)!
            analytics.service.register(.cleverTap)
        }
     }
     ```
     
     - Parameter provider: A wrapper over providers that allows you to select one of the predefined objects or add a new one.
     */
    func register(_ provider: ProviderImage)
    
    /**
     Registers the required analytics provider
     
     ### ⚠️ Important
     You must make sure that the Analytics instance is unique and is not overwritten during the application lifecycle.
     
     If the object is lost after the providers are registered, the `sendEvent` method will have no event dispatch targets.
     
     ### Example
     ```
     struct AnalyticsWrapper<T: AnalyticsProtocol> {
         let service: T
     }
     
     class AnalyticsService {
     
        func activateAnalytics() {
            let analytics = DI.container.resolve(AnalyticsWrapper<ClientAppAnalytics>.self)!
            analytics.service.register(.cleverTap, with [.accountId("XXX-YYY-ZZZ")])
        }
     }
     ```
     
     - Parameter provider: A wrapper over providers that allows you to select one of the predefined objects or add a new one.
     - Parameter settings: Settings applied to the provider.
     */
    func register(_ provider: ProviderImage, with settings: [ProviderSettings])
    
    // TODO: ⚠️ Add method to configure only one provider
    
    /**
     - Parameters:
        - settings: Settings applied to the provider.
     */
    func applyProvidersSettings(_ settings: [ProviderSettings])
    
    /**
     Tells the provider that a unique user is logged into the application
     - Parameter id: local user id on your system
     - Parameter name: local user name on your system
     - Parameter email: local user email on your system
     - Parameter phone: local user phone on your system
     */
    func updateUserInfo(with id: Any, _ name: String?, _ email: String?, _ phone: String?)
    
    /**
     Sends event information to all registered providers.
     
     ### ⚠️ Important
     You must make sure that the Analytics instance is unique and is not overwritten during the application lifecycle.
     
     If the object is lost after the providers are registered, the  method will have no event dispatch targets.
     
     - Parameters:
        - event: based on `AnalyticsEventProtocol` protocol. Implemented in the project.
     */
    func sendEvent(_ event: Event)
    
    /**
     Sends event information to all registered providers.
     
     The module name will be added before the event name.
     
     ### ⚠️ Important
     You must make sure that the Analytics instance is unique and is not overwritten during the application lifecycle.
     
     If the object is lost after the providers are registered, the  method will have no event dispatch targets.
     
     - Parameters:
        - event: based on `AnalyticsEventProtocol` protocol. Implemented in the project.
        - module: based on `AnalyticsModuleProtocol` protocol. Implemented in the project.
     */
    func sendEvent(_ event: Event, from module: Module?)
    
    /**
     Sends event information to all registered providers.
     
     The module name will be added before the event name.
     
     ### ⚠️ Important
     You must make sure that the Analytics instance is unique and is not overwritten during the application lifecycle.
     
     If the object is lost after the providers are registered, the method will have no event dispatch targets.
     
     - Parameters:
        - event: based on `AnalyticsEventProtocol` protocol. Implemented in the project.
        - params: based on `AnalyticsParamProtocol` protocol. Implemented in the project.
        - module: based on `AnalyticsModuleProtocol` protocol. Implemented in the project.
     */
    func sendEvent(_ event: Event, with params: [Param: Any]?, from module: Module?)
    
    // TODO: It seems that the method sendEvent(with params, and items) should be organized in some other way. At the moment, it is present unchanged in ProviderProtocol
    
    /// An optional method that allows you to pass an array of some objects to the provider, for example, a list of purchased goods with additional information for the receipt.
    /// - Parameters:
    ///   - params: Additional information for a group of transferred objects.
    ///   - items: Objects to be transferred to the provider
    func sendEvent(with params: [Param : Any], and items: [Any]?)
    
    /// Processes the user's fingers to push.
    /// - Parameter response: The user’s response to the notification. This object contains the original notification and the identifier string for the selected action. If the action allowed the user to provide a textual response, this parameter contains a `UNTextInputNotificationResponse` object.
    /// - Parameter completionHandler: A block that returns a tuple with a provider and data for its push notifications.
    func pressedPushNotification(with response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping ([(ProviderImage, [AnyHashable : Any])]) -> Void)
}

extension AnalyticsProtocol {
    public func updateUserInfo(with id: Any, _ name: String? = nil, _ email: String? = nil, _ phone: String? = nil) { }
    public func register(_ provider: ProviderImage, with settings: [ProviderSettings]) { }
    public func sendEvent(with params: [Param : Any], and items: [Any]?) { }
}
