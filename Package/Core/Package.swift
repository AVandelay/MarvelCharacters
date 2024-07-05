// swift-tools-version: 5.10

import PackageDescription

let package = Package(
    name: "Core",
    platforms: [.iOS(.v17), .macOS(.v14), .tvOS(.v17)],
    products: [
        .library(name: "Core", targets: ["Core"]),
        .library(name: "API", targets: ["API"]),
    ],
    targets: [
        // MARK: Core

        .target(
            name: "Core"),

        // MARK: Infrastructure

        .target(
            name: "API",
            dependencies: ["Core"]
        ),
    ]
)
