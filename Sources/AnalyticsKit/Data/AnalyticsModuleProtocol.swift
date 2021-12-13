//
//  AnalyticsModuleProtocol.swift
//  
//
//  Created by Johnnie Walker on 19.08.2021.
//

public protocol AnalyticsModuleProtocol {
    /**
     Provides part of the event name - the screen name (module) in the user interface.
     
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
    func name(for provider: AnalyticProviderType) -> String
}
