//
//  LogFileListItem.swift
//  AppQualityAssurance
//
//  Created by hiragram on 2022/12/12.
//

import SwiftUI

struct LogFileListItem: View {
    var filePath: URL
    var fileSize: Int

    var body: some View {
        HStack {
            Capsule()
                .frame(width: 4)
            VStack {
                Text("\(filePath.lastPathComponent)")
                    .frame(maxWidth: .infinity, alignment: .leading)
                Text("\(fileSize) B")
                    .frame(maxWidth: .infinity, alignment: .trailing)
            }
            .frame(maxWidth: .infinity)
        }
        .frame(height: 50)
        .contentShape(Rectangle())
    }
}

struct LogFileListItem_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            LogFileListItem(
                filePath: URL(string: "/Path/To/Logs/ghou4awpjhfeaw12345.json")!,
                fileSize: 33_465
            )
            Spacer()
        }
    }
}
