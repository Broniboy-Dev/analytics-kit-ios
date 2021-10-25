//
//  ProviderImage.swift
//  
//
//  Created by Johnnie Walker on 19.08.2021.
//

public enum ProviderImage {
    
    case cleverTap
    case other(_ provider: ProviderProtocol)
    
    func getInstance() -> ProviderProtocol {
        switch self {
        case .cleverTap:
            return CleverTapProvider()
        case .other(let provider):
            return provider
        }
    }
    
    static func getImage(from provider: ProviderProtocol) -> ProviderImage {
        if provider is CleverTapProvider {
            return .cleverTap
        } else {
            return .other(provider)
        }
    }
}
