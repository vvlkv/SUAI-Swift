// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SUAI-Swift",
    products: [
        .library(
            name: "SUAI-Swift",
            targets: ["SUAI-Swift"]),
    ],
    dependencies: [
        .package(url: "https://github.com/scinfu/SwiftSoup.git", from: "2.0.0")
    ],
    targets: [
        .target(name: "SUAI-Swift", dependencies: ["SwiftSoup"]),
        .testTarget(name: "SUAI-SwiftTests", dependencies: ["SUAI-Swift"]),
    ]
)
