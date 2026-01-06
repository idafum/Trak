// swift-tools-version: 6.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Trak",
    platforms: [
        .macOS(.v13)
    ],
    dependencies: [
      .package(url: "https://github.com/apple/example-package-figlet", branch: "main"),
      .package(url: "https://github.com/apple/swift-argument-parser", from: "1.3.0"),
      .package(url: "https://github.com/tuist/Noora", .upToNextMajor(from: "0.15.0")),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .executableTarget(
            name: "trak",
            dependencies: [
                .product(name: "Figlet", package: "example-package-figlet"),
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
                "Noora"
            ],
            path: "Sources"),
    ]
)
