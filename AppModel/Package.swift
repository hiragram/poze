// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "AppModel",
    platforms: [.iOS(.v17)],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "AppModel",
            targets: ["AppModel"]),
    ],
    dependencies: [
        .package(path: "../TestUtility"),
        .package(
            url: "https://github.com/hiragram/xcstrings-tool-plugin.git",
            from: "0.1.2"
        ),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "AppModel",
            dependencies: [
            ],
            plugins: [
                .plugin(name: "XCStringsToolPlugin", package: "xcstrings-tool-plugin"),
            ]
        ),
        .testTarget(
            name: "AppModelTests",
            dependencies: [
                "AppModel",
                .product(name: "TestUtility", package: "TestUtility"),
            ]
        ),
    ]
)
