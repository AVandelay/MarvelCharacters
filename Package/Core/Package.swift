// swift-tools-version: 5.10

import PackageDescription

let package = Package(
    name: "Core",
    platforms: [.iOS(.v17), .macOS(.v14), .tvOS(.v17)],
    products: [
        .library(name: "Core", targets: ["Core"]),
        .library(name: "API", targets: ["API"]),
        .library(name: "Services", targets: ["Services"]),
        .library(name: "CommonUI", targets: ["CommonUI"]),
        .library(name: "AppUI", targets: ["AppUI"]),
        .library(name: "LiveApp", targets: ["LiveApp"]),
    ],
    targets: [
        
        // MARK: Core

        .target(name: "Core"),

        // MARK: Infrastructure

        .target(
            name: "API",
            dependencies: ["Core"]
        ),

        // MARK: Services

        .target(
            name: "Services",
            dependencies: ["Core", "API", "AppUI"]
        ),

        // MARK: UI
        
        .target(
            name: "CommonUI",
            dependencies: ["Core"]
        ),
        .target(
            name: "AppUI",
            dependencies: ["Core", "CommonUI"]
        ),

        // MARK: Live Containers

        .target(
            name: "LiveApp",
            dependencies: ["Core", "API", "Services", "AppUI"]
        ),
    ]
)
