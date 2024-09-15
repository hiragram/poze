//
//  ContentView.swift
//  Catalog
//
//  Created by Yuya Hirayama on 2023/11/26.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack {
            List {
                ForEach(moduleList()) { module in
                    Section("\(module.name) Module") {
                        ForEach(module.screens) { screen in
                            ForEach(screen.previews) { preview in
                                NavigationLink("\(screen.name)/\(preview.name)") {
                                    preview.view
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
