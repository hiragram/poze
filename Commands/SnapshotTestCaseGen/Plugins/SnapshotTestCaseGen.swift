import PackagePlugin

@main
struct SnapshotTestCaseGen: BuildToolPlugin {
    /// Entry point for creating build commands for targets in Swift packages.
    func createBuildCommands(context: PluginContext, target: Target) async throws -> [Command] {
        fatalError()
    }
}

#if canImport(XcodeProjectPlugin)
import XcodeProjectPlugin

extension SnapshotTestCaseGen: XcodeBuildToolPlugin {
    // Entry point for creating build commands for targets in Xcode projects.
    func createBuildCommands(context: XcodePluginContext, target: XcodeTarget) throws -> [Command] {

        let appFeaturesPath = context.xcodeProject.directory.appending(subpath: "AppFeatures")
        let appCorePath = context.xcodeProject.directory.appending(subpath: "AppCore")

        print("moze", context.pluginWorkDirectory.string)

        return [
            .buildCommand(
                displayName: "Generating snapshot test case",
                executable: try context.tool(named: "sourcery").path,
                arguments: [
                    "--sources",
                    appFeaturesPath.string,
                    "--templates",
                    appCorePath.appending([
                        "Sources",
                        "AppCore",
                        "sourcery_templates",
                        "SnapshotTests.stencil",
                    ]),
                    "--output",
                    context.pluginWorkDirectory.string,
                    "--cacheBasePath",
                    context.pluginWorkDirectory.appending(subpath: "cache").string
                ],
                outputFiles: [
                    context.pluginWorkDirectory
                        .appending(subpath: "SnapshotTests.generated.swift")
                ]
            ),
            .buildCommand(
                displayName: "Generating screen previews",
                executable: try context.tool(named: "sourcery").path,
                arguments: [
                    "--sources",
                    appFeaturesPath.string,
                    "--templates",
                    appCorePath.appending([
                        "Sources",
                        "AppCore",
                        "sourcery_templates",
                        "ScreenPreviews.stencil",
                    ]),
                    "--output",
                    context.pluginWorkDirectory.string,
                    "--cacheBasePath",
                    context.pluginWorkDirectory.appending(subpath: "cache").string
                ],
                outputFiles: [
                    context.pluginWorkDirectory
                        .appending(subpath: "ScreenPreviews.generated.swift")
                ]
            ),
        ]
    }
}
#endif
