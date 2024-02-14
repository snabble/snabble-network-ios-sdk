// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SnabbleNetwork",
    platforms: [
        .iOS(.v15)
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "SnabbleNetwork",
            targets: ["SnabbleNetwork"]),
    ],
    dependencies: [
        .package(
            url: "https://github.com/lachlanbell/SwiftOTP",
            from: "3.0.2"),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "SnabbleNetwork",
            dependencies: ["SwiftOTP"],
            path: "Sources/Core"
        ),
        .testTarget(
            name: "SnabbleNetworkTests",
            dependencies: ["SnabbleNetwork"],
            path: "Tests/Core",
            resources: [
                .process("Resources")
            ]
        ),
    ]
)
