// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "PrettierPrinter",
    products: [
        .executable(
            name: "prpr",
            targets: ["PrettierPrinter"]
        ),
        .library(
            name: "PrettierPrinterCore",
            targets: ["PrettierPrinterCore"]
        ),
        .library(
            name: "PrettierPrinterParser",
            targets: ["PrettierPrinterParser"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser", .upToNextMinor(from: "0.4.0")),
    ],
    targets: [
        .executableTarget(
            name: "PrettierPrinter",
            dependencies: [
                "PrettierPrinterCore",
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
            ]
        ),
        .target(
            name: "PrettierPrinterCore",
            dependencies: ["PrettierPrinterParser"]
        ),
        .target(
            name: "PrettierPrinterParser",
            dependencies: []
        ),
        .testTarget(
            name: "PrettierPrinterTests",
            dependencies: ["PrettierPrinterCore"]
        ),
    ]
)
