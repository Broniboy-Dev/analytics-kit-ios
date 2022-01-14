//
//  ProviderConfigurationProtocol.swift
//  
//
//  Created by Johnnie Walker on 31.08.2021.
//

import Foundation

public enum ProviderSettings {
    case pushToken(_ token: Data)
    case accountId(_ id: String)
    case accountToken(_ token: String)
    case environment(_ environment: String)
    case networkReporting(_ isEnable: Bool)
    case fcmTokenCompletion(_ provider: AnalyticProviderType, _ completion: (String) -> Void)
    case logLevel(_ logLevel: AnalyticsLogLevel)
}
