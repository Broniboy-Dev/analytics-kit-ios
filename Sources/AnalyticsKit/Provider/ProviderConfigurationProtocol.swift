//
//  ProviderConfigurationProtocol.swift
//  
//
//  Created by Johnnie Walker on 31.08.2021.
//

import Foundation

public enum ProviderSettings {
    /**
     Use this case to set up only a `Ajust` provider
     
     - Parameters:
        - accountToken: Your account token (aka API token / key) from Ajust. [More info](https://help.adjust.com/en/article/your-data)
        - environment: Environment to post the data to (`environment = sandbox` or `environment = production`). If this parameter is not included, the event will be pushed to the production environment. [More info](https://help.adjust.com/en/article/your-data)
     
     */
    case adjustSettings(accountToken: String?, environment: String?)
    
    /**
     Use this case to set up only a `Amplitude` provider
     
     - Parameters:
        - accountToken: Your account token (aka API token / key) from Amplitude. [More info](https://developers.amplitude.com/docs/ios)
        - enableTrackingSession: Whether to include the standard session start and end events [More info](https://help.amplitude.com/hc/en-us/articles/115002323627-Track-sessions-in-Amplitude)
     */
    case amplitudeSettings(accountToken: String?, enableTrackingSession: Bool?)
    
    /**
     Use this case to set up only a `CleverTap` provider
     
     - Parameters:
        - accountId: Your account ID from CleverTap. [Mode info](https://developer.clevertap.com/docs/authentication)
        - accountToken: Your account token (aka API token / key) from CleverTap. [More info](https://developer.clevertap.com/docs/authentication)
        - enableNetworkReporting: Enable collection of data subject to GDPR. [More info](https://developer.clevertap.com/docs/sdk-changes-for-gdpr-compliance#section-device-network-information-reporting-in-i-os)
        - deviceToken: User device token
     */
    case cleverTapSettings(accountId: String?, accountToken: String?, enableNetworkReporting: Bool?, deviceToken: Data?)
    
    /**
     Use this case to set up only a `GoogleAnalytics (Firebase)` provider
     
     - Parameters:
        - pushTokenCompletion: The completion handler to handle the token request. [More info](https://firebase.google.com/docs/reference/swift/firebasemessaging/api/reference/Classes/Messaging#/c:objc(cs)FIRMessaging(im)tokenWithCompletion:)
        - deviceToken: User device token
     */
    case googleAnalyticsSettings(pushTokenCompletion: ((String) -> Void)?, deviceToken: Data?)
}
