//
//  AnalyticsParamProtocol.swift
//  
//
//  Created by Johnnie Walker on 19.08.2021.
//

public protocol AnalyticsParamProtocol: Hashable {
    /// Lets get the text value for a parameter
    /// - Parameter provider: A wrapper over providers that allows you to select one of the predefined objects or add a new one.
    func name(for provider: AnalyticProviderType) -> String
}
