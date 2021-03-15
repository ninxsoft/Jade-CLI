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
        .package(url: "https://github.com/apple/swift-argument-parser", from: "0.4.1"),
        .package(url: "https://github.com/jpsim/Yams", from: "4.0.4")
    ],
    targets: [
        .target(name: "JADE", dependencies: [
            .product(name: "ArgumentParser", package: "swift-argument-parser"),
            .product(name: "Yams", package: "Yams")
        ], path: "JADE")
    ]
)
