//
//  GoogleAnalyticsProvider.swift
//  
//
//  Created by Johnnie Walker on 07.12.2021.
//

import Foundation
import FirebaseCore
import FirebaseAnalytics
import FirebaseCrashlytics
import FirebaseMessaging
import CoreLocation
import UserNotifications

class GoogleAnalyticsProvider: NSObject, ProviderProtocol {
    // MARK: - Properties
    
    var type: AnalyticProviderType = .googleAnalytics
    var pushNotificationCustomExtras: [AnyHashable : Any]?
    private var pushTokenCompletion: ((String) -> Void)?
    
    // MARK: - ProviderProtocol
    
    func register() {
        // TODO: Not sure if Messaging delegate assignment is always required
        Messaging.messaging().delegate = self
        FirebaseApp.configure()
    }
    
    func updateUserInfo(
        _ id: Any?,
        _ name: String?,
        _ email: String?,
        _ phone: String?,
        _ location: CLLocationCoordinate2D?
    ) {
        // TODO: Refactoring
        // Write full implementation
        if let id = id as? String {
            Analytics.setUserID(id)
            
            // TODO: Refactoring
            // For Crushlytics make according to requirement
            Crashlytics.crashlytics().setUserID(id)
        }
    }

    func setDeviceToken(_ deviceToken: Data) {
        Messaging.messaging().apnsToken = deviceToken
    }
    
    func setAccountId(_ id: String) {
        // TODO: Write implementation
    }
    
    func setAccountToken(_ token: String) {
        // TODO: Write implementation
    }
    
    func sendEvent(_ event: String, with params: [String : Any]) {
        Analytics.logEvent(event, parameters: params)
    }
    
    func sendEvent(_ event: String) {
        Analytics.logEvent(event, parameters: nil)
    }
    
    func sendEvent(with params: [AnyHashable : Any], and items: [Any]) {
        // TODO: Explore this case in more detail
        print("[AnalyticsKit/Firebase] Google Analytics has no analogue of this function")
    }
    
    func sendEventRevenue(for provider: ProviderRevenue) {
        print("[AnalyticsKit/Firebase] Has no implementation of Revenue for GoogleAnalytics")
    }
    
    func setPushTokenCompletion(_ completion: @escaping (String) -> Void) {
        pushTokenCompletion = completion
    }
    
    func sendEventCrash(with error: Error) {
        Crashlytics.crashlytics().record(error: error)
    }
    
    func sendEventCrash(with message: String) {
        Crashlytics.crashlytics().log(message)
    }
    
    // TODO: Refactoring
    // Made to preserve the workflow of the BB client, but it seems that it needs some attention / refactoring.
    func getAndSaveToken() {
        Messaging.messaging().token { token, error in
            if let error = error {
                NSLog("[AnalyticsKit/Firebase]. Error fetching remote instange ID: \(error)")
            } else if let token = token {
                NSLog("[AnalyticsKit/Firebase]. Remote instance ID token: \(token)")
                guard let pushTokenCompletion = self.pushTokenCompletion else { return }
                pushTokenCompletion(token)
            }
        }
    }
}

// MARK: - MessagingDelegate

extension GoogleAnalyticsProvider: MessagingDelegate {
    func messaging(
        _ messaging: Messaging,
        didReceiveRegistrationToken fcmToken: String?
    ) {
        if let fcmToken = fcmToken {
            guard let fcmTokenCompletion = self.pushTokenCompletion else { return }
            fcmTokenCompletion(fcmToken)
        }
    }
}
