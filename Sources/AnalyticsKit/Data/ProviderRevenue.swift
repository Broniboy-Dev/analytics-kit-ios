//
//  ProviderRevenue.swift
//  AnalyticsKit
//
//  Created by Johnnie Walker on 20.03.2022.
//

import Foundation
import Adjust
import Amplitude
import YandexMobileMetrica

public enum ProviderRevenue {
    case appMetrica(_ info: YMMRevenueInfo)
    case adjust(_ info: ADJEvent)
    case amplitude(_ info: AMPRevenue)
}
