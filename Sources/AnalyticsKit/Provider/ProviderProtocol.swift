//
//  ProviderProtocol.swift
//  
//
//  Created by Johnnie Walker on 19.08.2021.
//

import Foundation
import UserNotifications

public protocol ProviderProtocol {
    
    var providerImage: ProviderImage { get set }
    
    var pushNotificationCustomExtras: [AnyHashable : Any]? { get set }
    
    /**
     The method calls the analytics provider's own SDK initializer.
     
     If you are using one of the predefined provider instances, then no initialization implementation is required. Otherwise, execute it in your project according to the documentation of the connected service.
     */
    func register()
    
    /**
     Tells the provider that a unique user is logged into the application
     - Parameter id: local user id on your system
     - Parameter name: local user name on your system
     - Parameter email: local user email on your system
     - Parameter phone: local user phone on your system
     */
    func updateUserInfo(_ id: Any, _ name: String?, _ email: String?, _ phone: String?)
    
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
    
    /// Handles push notification touch
    /// - Parameters:
    ///   - response: The user’s response to the notification. This object contains the original notification and the identifier string for the selected action. If the action allowed the user to provide a textual response, this parameter contains a `UNTextInputNotificationResponse` object.
    ///   - completionHandler: The block executed after the user clicks on the notification. The block returns push notification data
    func handleNotification(with response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping ([AnyHashable : Any]?) -> Void)
}

extension ProviderProtocol {
    func sendEvent(with params: [AnyHashable : Any], and items: [Any]) { }
    func setPushToken(deviceToken: Data) { }
    func setAccountId(_ id: String) { }
    func setAccountToken(_ token: String) { }
}
