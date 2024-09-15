// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "AppRepository",
    platforms: [.iOS(.v17)],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "AppRepository",
            targets: ["AppRepository"]),
    ],
    dependencies: [
        .package(url: "https://github.com/kishikawakatsumi/KeychainAccess.git", from: "4.0.0"),
        .package(name: "AppModel", path: "../AppModel"),
        .package(name: "AppCore", path: "../AppCore"),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "AppRepository",
            dependencies: [
                .product(name: "KeychainAccess", package: "KeychainAccess"),
                .product(name: "AppModel", package: "AppModel"),
                .product(name: "AppCore", package: "AppCore"),
            ]
        ),
        .testTarget(
            name: "AppRepositoryTests",
            dependencies: ["AppRepository"]),
    ]
)
