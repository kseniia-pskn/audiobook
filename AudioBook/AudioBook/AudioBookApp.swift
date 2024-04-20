//
//  AudioBookApp.swift
//  AudioBook
//
//  Created by Kseniia Piskun on 18.04.2024.
//

import SwiftUI
import ComposableArchitecture

@main
struct MyApp: App {
    var body: some Scene {
        WindowGroup {
            BookPlayerView(store: Store(initialState: BookSummaryReducer.State()) {
                BookSummaryReducer(environment: BookSummaryEnvironment())
              })
        }
    }
}
