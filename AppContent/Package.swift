// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let appFeatureNames: [String] = [
]

let package = Package(
    name: "AppContent",
    platforms: [.iOS(.v17)],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "AppContent",
            targets: ["AppContent"]),
    ],
    dependencies: [
        .package(path: "../AppCore"),
        .package(path: "../AppRepository"),
        .package(path: "../AppModel"),
    ] + appFeatureNames.map { appFeatureName in
        return .package(path: "../AppFeatures/\(appFeatureName)")
    },
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "AppContent",
            dependencies: [
                .product(name: "AppCore", package: "AppCore"),
                .product(name: "AppRepository", package: "AppRepository"),
                .product(name: "AppModel", package: "AppModel"),
            ] + appFeatureNames.map { appFeatureName in
                return .product(name: appFeatureName, package: appFeatureName)
            }
        ),
        .testTarget(
            name: "AppContentTests",
            dependencies: ["AppContent"]),
    ]
)
