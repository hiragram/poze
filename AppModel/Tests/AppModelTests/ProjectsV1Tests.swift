//
//  ProjectsV1.swift
//  
//
//  Created by Yuya Hirayama on 2024/01/08.
//

import XCTest
@testable import AppModel

final class ProjectsV1Tests: XCTestCase, ProjectStructureTests {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func test_saveしてloadできる() async throws {
        let projectURL = FileManager.default.temporaryDirectory.appending(path: UUID().uuidString)

        let date = Date.now

        let beforeSave = ProjectV1.Project(
            id: UUID(),
            title: "Title",
            createdAt: date,
            updatedAt: date
        )

        try await ProjectV1.saveProject(
            project: beforeSave,
            to: projectURL
        )

        let loaded = try await ProjectV1.loadProject(projectURL: projectURL)

        XCTAssertEqual(beforeSave.id, loaded.id)
        XCTAssertEqual(beforeSave.title, loaded.title)
        XCTAssertEqual(beforeSave.createdAt, loaded.createdAt)
        XCTAssertEqual(beforeSave.updatedAt, loaded.updatedAt)
    }

    func test_saveしてlatestまで変換できる() async throws {

        let projectURL = FileManager.default
            .temporaryDirectory
            .appending(
                path: UUID().uuidString
            )
        let project = ProjectV1.Project(
            id: .init(),
            title: "Title",
            createdAt: .now,
            updatedAt: .now
        )

        try await ProjectV1.saveProject(project: project, to: projectURL)

        let loaded = try await LatestStructureVersion
            .migrateAndLoadProject(
                projectURL: projectURL
            )

        XCTAssertEqual(loaded.metadata.projectID, project.id)
        XCTAssertEqual(loaded.metadata.createdAt, project.createdAt)
        XCTAssertEqual(loaded.metadata.updatedAt, project.updatedAt)
        XCTAssertEqual(loaded.sections.count, 0)
        XCTAssertEqual(loaded.songInfo.title, project.title)
    }

    func test_saveしてlatestまで変換してsaveできる() async throws {
        let projectURL = FileManager.default
            .temporaryDirectory
            .appending(path: UUID().uuidString)
        let project = ProjectV1.Project(
            id: .init(),
            title: "Title",
            createdAt: .now,
            updatedAt: .now
        )

        try await ProjectV1.saveProject(project: project, to: projectURL)

        let loaded = try await LatestStructureVersion
            .migrateAndLoadProject(
                projectURL: projectURL
            )

        try await LatestStructureVersion.saveProject(
            project: loaded,
            to: projectURL
        )
    }
}
