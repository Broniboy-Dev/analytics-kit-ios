//
//  AnalyticsEventProtocol.swift
//  
//
//  Created by Johnnie Walker on 19.08.2021.
//

public protocol AnalyticsEventProtocol {
    
    /**
     Provides part of the event name - a designation for a custom action.
     
     ### Important 👇
     The event name is appended to the module name. In general, it will look like this:
     ```
     // .appear - this is the event case, returned - "Appear"
     // .auth - this is the module case, returned - "AuthScreen"
     
     // When this call is triggered, an event named "AuthScreenAppear"
     // will be dispatched.
     analytics.service.sendEvent(.appear, from: .auth)
     
     ```
     
     - Parameter provider: A wrapper over providers that allows you to select one of the predefined objects or add a new one.
     */
    func name(for provider: ProviderImage) -> String
    
    /**
     Allows you to define which events should be sent to which provider.
     
     If no special permissions are required, just `return true`
     
     - Parameter provider: A wrapper over providers that allows you to select one of the predefined objects or add a new one.
     - Parameter event: A custom event instance retrieved from your application
     - Parameter module: The instance of the module in which the event occurred, received from your application
     */
    func getPermissionToSentEvent(_ event: AnalyticsEventProtocol, from module: AnalyticsModuleProtocol?, for provider: ProviderImage) -> Bool
}
