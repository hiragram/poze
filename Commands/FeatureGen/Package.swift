// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "FeatureGen",
    platforms: [.macOS(.v13)],
    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser.git", from: "1.2.0"),
        .package(url: "https://github.com/tuist/XcodeProj.git", .upToNextMajor(from: "8.12.0")),
        .package(url: "https://github.com/yonaskolb/Genesis.git", from: "0.1.0"),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .executableTarget(
            name: "featuregen",
            dependencies: [
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
                .product(name: "XcodeProj", package: "XcodeProj"),
                .product(name: "GenesisKit", package: "Genesis"),
            ],
            resources: [
                .process("Resources/View.stencil"),
                .process("Resources/Strings.stencil"),
                .process("Resources/Interactor.stencil"),
                .process("Resources/Presenter.stencil"),
                .process("Resources/Router.stencil"),
                .process("Resources/Package.stencil"),
                .process("Resources/gitignore.stencil"),
            ]
        ),
        .executableTarget(
            name: "featurelink",
            dependencies: [
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
                .product(name: "XcodeProj", package: "XcodeProj"),
            ]
        )
    ]
)
