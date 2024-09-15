// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SnapshotTestCaseGen",
    products: [
        // Products can be used to vend plugins, making them visible to other packages.
        .plugin(
            name: "SnapshotTestCaseGen",
            targets: ["SnapshotTestCaseGen"]
        ),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .plugin(
            name: "SnapshotTestCaseGen",
            capability: .buildTool(),
            dependencies: [
                .target(name: "SourceryBinary")
            ]
        ),
        .binaryTarget(
            name: "SourceryBinary",
            url: "https://github.com/krzysztofzablocki/Sourcery/releases/download/2.1.3/sourcery-2.1.3.artifactbundle.zip",
            checksum: "1b0df8136255072b8eb273dc01b152866d9c431f58c93f27c7feb1dd2f3ddb45"
        ),
    ]
)
