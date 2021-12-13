//
//  AnalyticProviderType.swift
//  
//
//  Created by Johnnie Walker on 19.08.2021.
//

public enum AnalyticProviderType {
    case amplitude
    case cleverTap
    case googleAnalytics
    case other(_ provider: ProviderProtocol)
    
    init(_ type: AnalyticProviderType) {
        switch type {
        case .amplitude:
            self = .amplitude
        case .cleverTap:
            self = .cleverTap
        case .googleAnalytics:
            self = .googleAnalytics
        case .other(let provider):
            self = .other(provider)
        }
    }
    
    func getInstance() -> ProviderProtocol {
        switch self {
        case .amplitude:
            return AmplitudeProvider()
        case .cleverTap:
            return CleverTapProvider()
        case .googleAnalytics:
            return GoogleAnalyticsProvider()
        case .other(let provider):
            return provider
        }
    }
    
    static func getType(from instance: ProviderProtocol) -> AnalyticProviderType {
        if instance is CleverTapProvider {
            return .cleverTap
        }
        else if instance is GoogleAnalyticsProvider {
            return .googleAnalytics
        } else {
            return .other(instance)
        }
    }
}
