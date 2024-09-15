//
//  LogCollector.swift
//  AppQualityAssurance
//
//  Created by hiragram on 2022/12/11.
//

import Foundation
import OSLog
import UIKit

let dateFormatter: ISO8601DateFormatter = {
    let f = ISO8601DateFormatter()
    f.timeZone = .current

    return f
}()

public class LogCollector {
    public static let shared = LogCollector(store: try! .init(scope: .currentProcessIdentifier))

    private var screenCaptureNotificationSubscription: Any?
    private var screenshotNotificationSubscription: Any?

    private init(store: OSLogStore) {
        self.store = store

        try! createLogDirectory()
        try! cleanupOldLogArchive()
    }

    let store: OSLogStore

    private func cleanupOldLogArchive() throws {
        let deletionTime: TimeInterval = 60 * 60 * 24 * 30 // 30日経過したログは削除する

        let logFilesToDelete = try exportedLogFiles()
            .compactMap {
                let attributes = try FileManager.default.attributesOfItem(atPath: $0.path.relativePath)
                if let creationDate = attributes[.creationDate] as? Date {
                    if creationDate < Date.now.addingTimeInterval(-1 * deletionTime) {
                        return $0
                    }
                }

                return nil
            }

        try logFilesToDelete.forEach { logFile in
            try FileManager.default.removeItem(at: logFile.path)
        }
    }

    public func applicationWillTerminate() {
        try! exportLogJSONSync()
    }

    private var logDirectory: URL {
        guard let documentDir = FileManager.default.urls(for: .libraryDirectory, in: .userDomainMask).first else {
            fatalError()
        }
        let destinationDir = documentDir.appendingPathComponent("logs")

        return destinationDir
    }

    func exportedLogFiles() throws -> [LogFile] {
        let logFiles = try FileManager.default.contentsOfDirectory(atPath: logDirectory.relativePath)
            .filter({ filename in
                filename.hasSuffix(".json")
            })
            .sorted(by: { a, b in
                a > b
            })
            .map { filename in
                let url = logDirectory.appendingPathComponent(filename, conformingTo: .json)
                let data = FileManager.default.contents(atPath: url.relativePath)!
                let fileSize = data.count

                return LogFile(path: url, fileSize: fileSize)
            }

        return logFiles
    }

    private func createLogDirectory() throws {
        try FileManager.default.createDirectory(at: logDirectory, withIntermediateDirectories: true)
    }

    private func exportLogJSON() async throws {
        try await withCheckedThrowingContinuation { continuation in
            do {
                try exportLogJSONSync()
                continuation.resume()
            } catch let error {
                continuation.resume(with: .failure(error))
            }
        }
    }

    private func exportLogJSONSync() throws {
        let logs = try collectLogEntriesSync()
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        let data = try encoder.encode(logs)

        let destinationDir = logDirectory
        let filename = "\(dateFormatter.string(from: Date())).json"
        let fileURL = destinationDir.appendingPathComponent(filename)

        try data.write(to: fileURL, options: .atomic)
    }

    private func collectLogEntriesSync() throws -> [LogEntry] {
        let result = try store.getEntries()
            .compactMap {
                $0 as? OSLogEntryLog
            }
            .filter {
                $0.subsystem == subsystemName
            }
            .map {
                LogEntry(
                    process: $0.process,
                    subsystem: $0.subsystem,
                    category: $0.category,
                    date: $0.date,
                    message: $0.composedMessage
                )
            }

        return result
    }

    struct LogEntry: Encodable {
        var process: String
        var subsystem: String
        var category: String
        var date: Date
        var message: String
    }

    struct LogFile: Identifiable, Hashable {
        var id: String {
            path.absoluteString
        }

        var path: URL
        var fileSize: Int
    }
}
