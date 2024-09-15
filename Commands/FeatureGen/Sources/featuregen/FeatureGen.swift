// The Swift Programming Language
// https://docs.swift.org/swift-book
// 
// Swift Argument Parser
// https://swiftpackageindex.com/apple/swift-argument-parser/documentation

import Foundation
import ArgumentParser
import PathKit
import XcodeProj
import GenesisKit

@main
struct FeatureGen: AsyncParsableCommand {

    @ArgumentParser.Argument(help: "Path to xcodeproj", transform: Path.init(stringLiteral:))
    var xcodeprojPath: Path

    @ArgumentParser.Argument(help: "Feature name")
    var featureName: String

    @ArgumentParser.Argument(help: "Screen name")
    var screenName: String

    func run() async throws {
        // Generate files for new package
        try generateFiles()
        
        // Add to workspace
        try addToWorkspace()
    }
    
    private func addToWorkspace() throws {
        let workspacePath = xcodeprojPath.parent() + Path("App.xcworkspace")
        let workspace = try XCWorkspace(path: workspacePath)

        let appFeatureGroupIndex = workspace.data.children.firstIndex { child in
            switch child {
            case .group(let group) where group.name == "AppFeatures":
                return true
            default:
                return false
            }
        }!
        
        let appFeatureGroup = switch workspace.data.children[appFeatureGroupIndex] {
        case .group(let group):
            group
        default:
            fatalError()
        }
        
        if !appFeatureGroup.children.contains(where: { child in
            child.location.path == "AppFeatures/\(featureName)"
        }) {
            appFeatureGroup.children.append(
                .file(
                    .init(
                        location: .group("AppFeatures/\(featureName)")
                    )
                )
            )
        }
        
        appFeatureGroup.children.forEach { child in
            print(child.location)
        }
        
        workspace.data.children[appFeatureGroupIndex] = .group(appFeatureGroup)
        
        try workspace.write(path: workspacePath)
    }
    
    private func generateFiles() throws {
        let filesToGenerate: [GenesisKit.File] = [
            .init(
                type: .contents(try stencilURL(name: "Package").contentString),
                path: "\(featureName)/Package.swift"
            ),
            .init(
                type: .contents(try stencilURL(name: "View").contentString),
                path: "\(featureName)/Sources/\(featureName)/Screens/\(screenName)/\(screenName)View.swift"
            ),
            .init(
                type: .contents(try stencilURL(name: "Presenter").contentString),
                path: "\(featureName)/Sources/\(featureName)/Screens/\(screenName)/\(screenName)Presenter.swift"
            ),
            .init(
                type: .contents(try stencilURL(name: "Router").contentString),
                path: "\(featureName)/Sources/\(featureName)/Screens/\(screenName)/\(screenName)Router.swift"
            ),
            .init(
                type: .contents(try stencilURL(name: "Interactor").contentString),
                path: "\(featureName)/Sources/\(featureName)/Screens/\(screenName)/\(screenName)Interactor.swift"
            ),
            .init(
                type: .contents(try stencilURL(name: "Strings").contentString),
                path: "\(featureName)/Sources/\(featureName)/Screens/\(screenName)/\(screenName).xcstrings"
            ),
            .init(
                type: .contents("import AppCore\n\nprivate struct \(featureName)Module: FeatureModule {} // for Sourcery"),
                path: "\(featureName)/Sources/\(featureName)/_\(featureName).swift"
            ),
            .init(
                type: .contents(""),
                path: "\(featureName)/Tests/\(featureName)Tests/\(featureName)Tests.swift"
            ),
            .init(
                type: .contents(try stencilURL(name: "gitignore").contentString),
                path: "\(featureName)/.gitignore"
            ),
        ]

        try generateFile(files: filesToGenerate)
    }

    private func stencilURL(name: String) -> URL {
        Bundle.module.url(forResource: name, withExtension: "stencil")!
    }

    private func generateFile(files: [GenesisKit.File]) throws {
        let template = GenesisTemplate(
            path: xcodeprojPath.parent(),
            section: .init(
                files: files
            )
        )
        let generator = try TemplateGenerator(template: template)

        let context: [String: Any] = [
            "featureName": featureName,
            "screenName": screenName,
        ]
        
        try generator
            .generate(context: context, interactive: false)
            .writeFiles(path: xcodeprojPath.parent() + Path("AppFeatures"))
    }
}
