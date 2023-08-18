//
//  motion2operate_macApp.swift
//  motion2operate-mac
//
//  Created by rei.nakaoka on 2023/08/13.
//

import SwiftUI

@main
struct motion2operate_macApp: App {

    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
