// The Swift Programming Language
// https://docs.swift.org/swift-book
// 
// Swift Argument Parser
// https://swiftpackageindex.com/apple/swift-argument-parser/documentation

import Foundation
import ArgumentParser
import PathKit
import XcodeProj

@main
struct FeatureLink: AsyncParsableCommand {

    @ArgumentParser.Argument(help: "Path to xcodeproj", transform: Path.init(stringLiteral:))
    var xcodeprojPath: Path

    func run() async throws {
        do {
            let appXcodeProj = try XcodeProj(path: xcodeprojPath)
            
            do {
                try linkAllFeature(linkTargetName: "Catalog", xcodeproj: appXcodeProj)
            }
            
            do {
                try linkAllFeature(linkTargetName: "AppSnapshotTests", xcodeproj: appXcodeProj)
            }
            
            try appXcodeProj.writePBXProj(path: xcodeprojPath, outputSettings: .init())
        }
    }
    
    private func linkAllFeature(linkTargetName: String, xcodeproj appXcodeProj: XcodeProj) throws {
        print("--- Start processing \(linkTargetName) ------------")
        let workspacePath = xcodeprojPath.parent() + Path("App.xcworkspace")
        let workspace = try! XCWorkspace(path: workspacePath)

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
        
        let appFeatures = appFeatureGroup.children.compactMap { child in
            switch child {
            case .file(let file) where file.location.path.hasPrefix("AppFeatures/"):
                return file
            default:
                return nil
            }
        }
                        
        let appFeatureDependencies = appFeatures.map { appFeature in
            XCSwiftPackageProductDependency(
                productName: appFeature.location.path.split(separator: "/").last.map(String.init)!
            )
        }
        
        let nativeTarget = appXcodeProj.pbxproj.nativeTargets.first(where: { target in
            target.name == linkTargetName
        })!
        
        appFeatureDependencies.forEach { appFeatureDependency in
            let packageDependency = XCSwiftPackageProductDependency(productName: appFeatureDependency.productName)

            if !nativeTarget.packageProductDependencies.contains(where: { $0.productName == appFeatureDependency.productName }) {
                appXcodeProj.pbxproj.add(object: packageDependency)
                nativeTarget.packageProductDependencies.append(packageDependency)
            }
            
            if try! !nativeTarget.frameworksBuildPhase()!.files!.contains(where: { $0.product?.productName == appFeatureDependency.productName }) {
                let pbxBuildFile = PBXBuildFile(product: packageDependency)
                try! nativeTarget.frameworksBuildPhase()!.files?.append(pbxBuildFile)
                appXcodeProj.pbxproj.add(object: pbxBuildFile)
            }
        }
    }
}
