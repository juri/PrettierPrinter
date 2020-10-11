// swift-tools-version:5.3
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
    dependencies: [],
    targets: [
        .target(
            name: "PrettierPrinter",
            dependencies: ["PrettierPrinterCore"]
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
