//
//  AnalyticsProtocol.swift
//  
//
//  Created by Johnnie Walker on 19.08.2021.
//

import Foundation
import UserNotifications
import CoreLocation

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
     // TODO: Rewrite the example
     ```
     
     - Parameter provider: A wrapper over providers that allows you to select one of the predefined objects or add a new one.
     */
    func register(_ provider: AnalyticProviderType)
    
    /**
     Registers the required analytics provider
     
     ### ⚠️ Important
     You must make sure that the Analytics instance is unique and is not overwritten during the application lifecycle.
     
     If the object is lost after the providers are registered, the `sendEvent` method will have no event dispatch targets.
     
     ### Example
     ```
     // TODO: Rewrite the example
     ```
     - Parameters:
       - provider: A wrapper over providers that allows you to select one of the predefined objects or add a new one.
       - settings: Settings applied to the provider.
     */
    func register(_ provider: AnalyticProviderType, with settings: ProviderSettings)
    
    // TODO: ⚠️ Add method to configure only one provider
    
    /**
     - Parameters:
       - provider: A wrapper over providers that allows you to select one of the predefined objects or add a new one.
       - settings: Settings applied to the provider.
     */
    func updateSettings(of provider: AnalyticProviderType, by settings: ProviderSettings)
    
    /**
     Tells the provider that a unique user is logged into the application
     - Parameters:
       - id: local user id on your system
       - name: local user name on your system
       - email: local user email on your system
       - phone: local user phone on your system
       - location: user coordinates (latitude longitude)
     */
    func updateUserInfo(_ id: Any?, _ name: String?, _ email: String?, _ phone: String?, _ location: CLLocationCoordinate2D?)
    
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
    
    // TODO: Refactoring
    // Made to preserve the workflow of the BB client, but it seems that it needs some attention / refactoring.
    // Do not use in other projects ⚠️
    func sendTags(_ tags: [String: AnyHashable])
    
    // TODO: Refactoring
    // Made to preserve the workflow of the BB client, but it seems that it needs some attention / refactoring.
    // Do not use in other projects ⚠️
    // Parameter passing is made of type String - this is not valid hardcode 😅😅😅
    func sendEventRevenue(with params: [String: Any])
    
    /// Processes the user's fingers to push.
    /// - Parameter response: The user’s response to the notification. This object contains the original notification and the identifier string for the selected action. If the action allowed the user to provide a textual response, this parameter contains a `UNTextInputNotificationResponse` object.
    /// - Parameter completionHandler: A block that returns a tuple with a provider and data for its push notifications.
    func pressedPushNotification(with response: UNNotificationResponse, _ completionHandler: @escaping ([(AnalyticProviderType, [AnyHashable : Any])]) -> Void)
    
    
    func sendEventCrash(with error: Error)
    
    func sendEventCrash(with message: String)
    
    // TODO: Refactoring
    // Made to preserve the workflow of the BB client, but it seems that it needs some attention / refactoring.
    // Do not use in other projects ⚠️
    func getAndSaveToken()
    
    // TODO: Refactoring
    // Made to preserve the workflow of the BB client, but it seems that it needs some attention / refactoring.
    // Do not use in other projects ⚠️
    func sendEventOrderCreated(_ event: String, revenue: Double?, transactionId: String?)
}

extension AnalyticsProtocol {
    public func updateUserInfo(_ id: Any?, _ name: String?, _ email: String?, _ phone: String?, _ location: CLLocationCoordinate2D?) { }
    public func register(_ provider: AnalyticProviderType, with settings: [ProviderSettings]) { }
    public func sendEvent(with params: [Param : Any], and items: [Any]?) { }
    public func sendTags(_ tags: [String: AnyHashable]) { }
    public func sendEventRevenue(with params: [String: Any]) { }
    public func sendEventCrash(with error: Error) { }
    public func sendEventCrash(with message: String) { }
    
    // TODO: Refactoring
    // Made to preserve the workflow of the BB client, but it seems that it needs some attention / refactoring.
    // Do not use in other projects ⚠️
    public func getAndSaveToken() { }
    
    // TODO: Refactoring
    // Made to preserve the workflow of the BB client, but it seems that it needs some attention / refactoring.
    // Do not use in other projects ⚠️
    public func sendEventOrderCreated(_ event: String, revenue: Double?, transactionId: String?) { }
}
