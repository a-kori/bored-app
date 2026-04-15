//
//  BoredApp.swift
//

import SwiftUI

@main
struct BoredApp: App {
    @State private var bookmarkViewModel = BookmarkViewModel()
    
    var body: some Scene {
        WindowGroup {
            ActivityBoardView()
                .environment(bookmarkViewModel)
        }
    }
}
