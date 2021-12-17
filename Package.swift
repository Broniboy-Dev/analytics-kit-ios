// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "AnalyticsKit",
    platforms: [
        .iOS(.v11)
    ],
    products: [
        .library(
            name: "AnalyticsKit",
            targets: ["AnalyticsKit"]
        ),
    ],
    dependencies: [
        .package(
            name: "Adjust",
            url: "https://github.com/adjust/ios_sdk",
            .branch("master")
        ),
        .package(
            name: "Amplitude",
            url: "https://github.com/amplitude/Amplitude-iOS",
            .branch("main")
        ),
        .package(
            name: "CleverTapSDK",
            url: "https://github.com/CleverTap/clevertap-ios-sdk",
            .branch("master")
        ),
        .package(
            name: "Firebase",
            url: "https://github.com/firebase/firebase-ios-sdk",
            .branch("master")
        )
    ],
    targets: [
        .target(
            name: "AnalyticsKit",
            dependencies: [
                .product(name: "Amplitude", package: "Amplitude"),
                .product(name: "Adjust", package: "Adjust"),
                .product(name: "CleverTapSDK", package: "CleverTapSDK"),
                .product(name: "FirebaseAuth", package: "Firebase"),
                .product(name: "FirebaseAnalytics", package: "Firebase"),
                .product(name: "FirebaseCrashlytics", package: "Firebase"),
                .product(name: "FirebaseMessaging", package: "Firebase")
            ]
        ),
        .testTarget(
            name: "AnalyticsKitTests",
            dependencies: ["AnalyticsKit"]
        ),
    ]
)
