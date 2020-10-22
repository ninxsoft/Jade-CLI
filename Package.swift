// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "JADE",
    platforms: [
        .macOS(.v10_10)
    ],
    products: [
        .executable(name: "jade", targets: ["JADE"])
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser", from: "0.3.1")
    ],
    targets: [
        .target(name: "JADE", dependencies: [
            .product(name: "ArgumentParser", package: "swift-argument-parser")
        ], path: "JADE")
    ]
)
