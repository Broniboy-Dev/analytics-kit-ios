# 🦋 AnalyticsKit

[![Build Status](https://img.shields.io/badge/Swift-5-orange)](https://developer.apple.com/swift) [![Build Status](https://img.shields.io/badge/SPM-compatible-green)](https://swift.org/package-manager/)

AnalyticsKit for Swift is designed to combine various analytical services into one simple tool.

To send information about a custom event to a dozen analytics providers at once, one line is enough. Like this!

```swift
analytics.sendEvent(.appear, from: .order)
```
  
## 🌱 Getting started
Method calls happen in the `AnalyticsKit` class, you need to instantiate it. Passing your implementation of the protocols
- `AnalyticsModuleProtocol`
- `AnalyticsEventProtocol`
- `AnalyticsParamProtocol`

```swift
let analytics = AnalyticsKit<Module, Event, Param>()
```

Your implementation of the punctures should provide the `AnalyticsKit` with the text data that will be passed to the providers. The most convenient way to do this is through an enum:

```swift
// A "Module" refers to a user interface or screen.
// Most likely your implementation consists of several classes,
// so the definition of "Module" seems correct.
enum Module: AnalyticsModuleProtocol {
    case order
    func name(for provider: ProviderProxy) -> String {
        switch self {
        case .order: return "Order"
        }
    }
}

enum Event: AnalyticsEventProtocol {
    case appear
    case buy
    func name(for provider: ProviderProxy) -> String {
        switch self {
        case .appear: return "_Appear"
        case .buy: return "_Buy" 
        }
    }
}

enum Param: AnalyticsParamProtocol {
    case name
    case price
    func name(for provider: ProviderProxy) -> String {
        switch self {
        case .name: return "name"
        case .price: return "price"
        }
    }
}
```

Before sending an event, you need to register an analytics provider. AnalyticsKit contains some predefined values, but you can add a new provider as well.

```swift
analytics.register(.cleverTap)
analytics.register(.other(_ provider: ProviderProtocol))
```

## ⚠️ Important
It is important that for correct operation, it is required that the AnalyticsKit instance is not removed from memory during the life cycle of the application. Otherwise, the list of providers that you registered earlier will be cleared, and the events sent will simply have nowhere to go.

Alternatively, you can use the Singleton pattern or use a dependency manager convenient for you, for example [Swinject](https://github.com/Swinject/Swinject)

## 📨 Sending data

You have created events and parameters, now is the time to send information about custom actions to all your analytics providers at once! 🤩

```swift
// An event named "Order_Appear" will be sent without additional parameters.
// Note that AnalyticsKit glues the event name and the module name.
analytics.sendEvent(.appear, from: .order)

// An event with the name "Buy_Order" will be sent with the parameters:
// name = "Pizza"
// price = "10 $"
var params: [AppAnalyticsParam : Any] = [:]
params[.name] = "Pizza"
params[.price] = "10$"
analytics.sendEvent(.buy, with: params, from: .order)

// If you don't like the fact that the event name is composed of two halves, just do not pass the module name to the function sendEvent().
analytics.sendEvent(.buy)
```

## 🎨 Fine tuning
You can customize the names of events and parameters for different providers, according to the requirements of your analysts

```swift
func name(for provider: ProviderProxy) -> String {
    switch self {
    case .buy:
        switch provider {    
        case .cleverTap     : return "_Buy"
        case .google        : return "_User_Click_Buy_Button"
        case .amplitude     : return "ClickBuy"
        default             : return "buy"
        }
    }
}
```

You can choose which events to send to one and not send to another provider. For this, the function has been created `getPermissionToSentEvent(_:from:for:)`

```swift
// For example, such an implementation will prohibit sending the Appear_Order event to any provider.
func getPermissionToSentEvent(_ event: AnalyticsEventProtocol, from module: AnalyticsModuleProtocol?, for provider: ProviderProxy) -> Bool {
    guard let event = event as? Event, let module = module as? Module else { return false }
    if case event == .appear, case module == .order {
        return false
    }
    return true
}

// To allow dispatch of all events, just return true
func getPermissionToSentEvent (_ event: AnalyticsEventProtocol, from module: AnalyticsModuleProtocol?, for provider: ProviderProxy) -> Bool {
    return true
}
```
