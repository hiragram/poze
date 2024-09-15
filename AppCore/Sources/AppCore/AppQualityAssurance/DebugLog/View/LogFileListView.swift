//
//  LogFileListView.swift
//  AppQualityAssurance
//
//  Created by hiragram on 2022/12/12.
//

import SwiftUI

public struct LogFileListView: View {
    @State private var logFiles: [LogCollector.LogFile]? = nil
    @State private var copiedToClipboardDialogIsPresented = false

    public init() {
    }

    public var body: some View {
        Group {
            if let logFiles {
                if logFiles.isEmpty {
                    noContent
                } else {
                    list(logFiles: logFiles)
                }
            } else {
                ProgressView()
            }
        }
        .onAppear {
            Task {
                let logFiles = try! LogCollector.shared.exportedLogFiles()
                self.logFiles = logFiles
            }
        }
        .alert(
            "Copied",
            isPresented: $copiedToClipboardDialogIsPresented,
            actions: {
                Button("OK") {

                }
            },
            message: {

            }
        )
    }

    @MainActor @ViewBuilder private func list(logFiles: [LogCollector.LogFile]) -> some View {
        List {
            ForEach(logFiles, id: \.id) { logFile in
                Button(
                    action: {
                        let data = FileManager.default.contents(atPath: logFile.path.relativePath)!
                        let str = String(data: data, encoding: .utf8)
                        UIPasteboard.general.string = str
                        copiedToClipboardDialogIsPresented = true
                    },
                    label: {
                        LogFileListItem(
                            filePath: logFile.path,
                            fileSize: logFile.fileSize
                        )
                        .tint(.black)
                    }
                )
            }
        }
    }

    @ViewBuilder private var noContent: some View {
        Text("No logs are stored.")
    }
}

struct LogFileListView_Previews: PreviewProvider {
    static var previews: some View {
        LogFileListView()
    }
}
