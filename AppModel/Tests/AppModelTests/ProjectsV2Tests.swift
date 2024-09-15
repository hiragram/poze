//
//  ProjectsV2Tests.swift
//  
//
//  Created by Yuya Hirayama on 2024/01/08.
//

import XCTest
@testable import AppModel

final class ProjectsV2Tests: XCTestCase, ProjectStructureTests {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func test_saveしてloadできる() async throws {
        let projectURL = FileManager.default.temporaryDirectory.appending(path: UUID().uuidString)

        let date = Date.now

        let beforeSave = ProjectV2.Project(
            metadata: .init(
                projectID: UUID(),
                createdAt: date,
                updatedAt: date
            ),
            sections: [
                .init(
                    sectionID: UUID(),
                    name: "Section1",
                    measures: [],
                    bpmOverride: nil,
                    keyOverride: nil,
                    timeSignatureOverride: nil
                ),
                .init(
                    sectionID: UUID(),
                    name: "Section2",
                    measures: [],
                    bpmOverride: nil,
                    keyOverride: nil,
                    timeSignatureOverride: nil
                ),
            ],
            songInfo: .init(
                title: "Title",
                scale: .init(rootNote: .c, scaleType: .major),
                bpm: 120,
                timeSignature: .init(
                    baseNote: .quarter,
                    count: .four
                )
            )
        )

        try await ProjectV2.saveProject(
            project: beforeSave,
            to: projectURL
        )

        let loaded = try await ProjectV2.loadProject(projectURL: projectURL)

        XCTAssertEqual(beforeSave.metadata.projectID, loaded.metadata.projectID)
        XCTAssertEqual(beforeSave.metadata.createdAt, loaded.metadata.createdAt)
        XCTAssertEqual(beforeSave.metadata.updatedAt, beforeSave.metadata.updatedAt)
        XCTAssertEqual(beforeSave.sections.count, loaded.sections.count)
        XCTAssertEqual(beforeSave.sections[0].sectionID, loaded.sections[0].sectionID)
        XCTAssertEqual(beforeSave.sections[0].name, loaded.sections[0].name)
        XCTAssertEqual(beforeSave.songInfo.title, loaded.songInfo.title)
        XCTAssertEqual(beforeSave.songInfo.timeSignature.baseNote, loaded.songInfo.timeSignature.baseNote)
        XCTAssertEqual(beforeSave.songInfo.timeSignature.count, loaded.songInfo.timeSignature.count)
    }

    func test_saveしてlatestまで変換できる() async throws {
        let projectURL = FileManager.default
            .temporaryDirectory
            .appending(path: UUID().uuidString)

        let project = ProjectV2.Project(
            metadata: .init(
                projectID: UUID(),
                createdAt: .now,
                updatedAt: .now
            ),
            sections: [
                .init(
                    sectionID: UUID(),
                    name: "Section1",
                    measures: [],
                    bpmOverride: nil,
                    keyOverride: nil,
                    timeSignatureOverride: nil
                )
            ],
            songInfo: .init(
                title: "Title",
                scale: .init(rootNote: .c, scaleType: .major),
                bpm: 120,
                timeSignature: .init(
                    baseNote: .quarter,
                    count: .four
                )
            )
        )

        try await ProjectV2.saveProject(project: project, to: projectURL)

        let loaded = try await LatestStructureVersion
            .migrateAndLoadProject(projectURL: projectURL)

        XCTAssertEqual(loaded.metadata.projectID, project.metadata.projectID)
        XCTAssertEqual(loaded.metadata.createdAt, project.metadata.createdAt)
        XCTAssertEqual(loaded.metadata.updatedAt, project.metadata.updatedAt)
        XCTAssertEqual(loaded.sections.count, project.sections.count)
        XCTAssertEqual(loaded.songInfo.title, project.songInfo.title)
        XCTAssertEqual(loaded.songInfo.timeSignature.baseNote, project.songInfo.timeSignature.baseNote)
        XCTAssertEqual(loaded.songInfo.timeSignature.count, project.songInfo.timeSignature.count)
    }

    func test_saveしてlatestまで変換してsaveできる() async throws {
        let projectURL = FileManager.default
            .temporaryDirectory
            .appending(path: UUID().uuidString)
        let project = ProjectV2.Project(
            metadata: .init(
                projectID: .init(),
                createdAt: .now,
                updatedAt: .now
            ),
            sections: [
                .init(
                    sectionID: .init(),
                    name: "Section1",
                    measures: [],
                    bpmOverride: nil,
                    keyOverride: nil,
                    timeSignatureOverride: nil
                ),
            ],
            songInfo: .init(
                title: "Title",
                scale: .init(rootNote: .c, scaleType: .major),
                bpm: 120,
                timeSignature: .init(
                    baseNote: .quarter,
                    count: .four
                )
            )
        )

        try await ProjectV2.saveProject(project: project, to: projectURL)

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
