//
//  ProviderProtocol.swift
//  
//
//  Created by Johnnie Walker on 19.08.2021.
//

import Foundation
import UserNotifications
import CoreLocation

// TODO: come up with a universal or other provider configuration!!!

public protocol ProviderProtocol {
    var type: AnalyticProviderType { get set }
    
    var pushNotificationCustomExtras: [AnyHashable : Any]? { get set }
    
    /**
     The method calls the analytics provider's own SDK initializer.
     
     If you are using one of the predefined provider instances, then no initialization implementation is required. Otherwise, execute it in your project according to the documentation of the connected service.
     */
    func register()
    
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
     Register the device to receive push notifications.
     
     This will associate the device token with the current user to allow push notifications to the user.
     
     - Parameter deviceToken: device token as returned from application:didRegisterForRemoteNotificationsWithDeviceToken:
     */
    func setPushToken(deviceToken: Data)
    
    /// Configures an account identifier for the provider. As a rule, any provider has such information, which can be found in the documentation of a particular provider.
    /// - Parameter id: An identifier that allows you to associate your analytics provider account with the application.
    func setAccountId(_ id: String)
    
    /// Configures an account token key for the provider. As a rule, any provider has such information, which can be found in the documentation of a particular provider.
    /// - Parameter token: A character value that will grant authorized access to the account.
    func setAccountToken(_ token: String)
    
    // TODO: Write documentation
    func setEnvironment(_ environment: String)
    
    // TODO: Write documentation
    func setFCMTokenCompletion(_ completion: @escaping (String) -> Void)
    
    /// Calls the provider's own SDK method to send data.
    /// - Parameters:
    ///   - event: Prepared (formatted) event name
    ///   - params: Additional parameters available for the event
    func sendEvent(_ event: String, with params: [String: Any])
    
    /// Calls the provider's own SDK method to send data.
    /// - Parameter event: Prepared (formatted) event name
    func sendEvent(_ event: String)
    
    /// An optional method that allows you to pass an array of some objects to the provider, for example, a list of purchased goods with additional information for the receipt.
    /// - Parameters:
    ///   - params: Additional information for a group of transferred objects.
    ///   - items: Objects to be transferred to the provider
    func sendEvent(with params: [AnyHashable : Any], and items: [Any])
    
    // TODO: Refactoring
    // Made to preserve the workflow of the BB client, but it seems that it needs some attention / refactoring.
    func sendTags(_ tags: [String: AnyHashable])
    
    // TODO: Refactoring
    // Made to preserve the workflow of the BB client, but it seems that it needs some attention / refactoring.
    func sendEventRevenue(with params: [String: Any])
    
    /// Handles push notification touch
    /// - Parameters:
    ///   - response: The user’s response to the notification. This object contains the original notification and the identifier string for the selected action. If the action allowed the user to provide a textual response, this parameter contains a `UNTextInputNotificationResponse` object.
    ///   - completionHandler: The block executed after the user clicks on the notification. The block returns push notification data
    func handleNotification(with response: UNNotificationResponse, _ completionHandler: @escaping ([AnyHashable : Any]?) -> Void)
    
    /// Enables the reporting of device network-related information, including IP address.  This reporting is disabled by default.
    ///
    /// Use this method to enable device network-related information tracking, including IP address. This reporting is disabled by default.  To re-disable tracking call this method with enabled set to NO.
    /// - Parameters:
    ///   - value: Whether device network info reporting should be enabled/disabled.
    func enableDeviceNetworkInfoReporting(_ value: Bool)
    
    func sendEventCrash(with error: Error)
    
    func sendEventCrash(with message: String)
    
    // TODO: Refactoring
    // Made to preserve the workflow of the BB client, but it seems that it needs some attention / refactoring.
    func getAndSaveToken()
    
    // TODO: Refactoring
    // Made to preserve the workflow of the BB client, but it seems that it needs some attention / refactoring.
    func sendEventOrderCreated(_ event: String, revenue: Double?, transactionId: String?)
}

extension ProviderProtocol {
    func sendEvent(with params: [AnyHashable : Any], and items: [Any]) { }
    
    // TODO: Refactoring
    // Made to preserve the workflow of the BB client, but it seems that it needs some attention / refactoring.
    func sendTags(_ tags: [String: AnyHashable]) { }
    
    // TODO: Refactoring
    // Made to preserve the workflow of the BB client, but it seems that it needs some attention / refactoring.
    func sendEventRevenue(with params: [String: Any]) { }
    
    func setPushToken(deviceToken: Data) { }
    func setAccountId(_ id: String) { }
    func setAccountToken(_ token: String) { }
    func setEnvironment(_ environment: String) { }
    func setFCMTokenCompletion(_ completion: @escaping (String) -> Void) { }
    func handleNotification(with response: UNNotificationResponse, _ completionHandler: @escaping ([AnyHashable : Any]?) -> Void) { }
    func enableDeviceNetworkInfoReporting(_ value: Bool) { }
    func sendEventCrash(with error: Error) { }
    func sendEventCrash(with message: String) { }
    
    // TODO: Refactoring
    // Made to preserve the workflow of the BB client, but it seems that it needs some attention / refactoring.
    func getAndSaveToken() { }
    
    // TODO: Refactoring
    // Made to preserve the workflow of the BB client, but it seems that it needs some attention / refactoring.
    func sendEventOrderCreated(_ event: String, revenue: Double?, transactionId: String?) { }
}
