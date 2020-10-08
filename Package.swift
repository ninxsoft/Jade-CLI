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
        .package(url: "https://github.com/kishikawakatsumi/KeychainAccess", from: "4.2.1")
    ],
    targets: [
        .target(name: "JADE", dependencies: ["KeychainAccess"], path: "JADE")
    ]
)
