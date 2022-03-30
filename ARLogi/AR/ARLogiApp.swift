//
//  ARLogiApp.swift
//  ARLogi
//
//  Created by Difa N Pratama on 31/01/22.
//

import SwiftUI

@main
struct ARLogiApp: App {
    @StateObject var placementSettings = PlacementSettings()
    @StateObject var sessionSettings = SessionSettings()
    @StateObject var sceneManager = SceneManager()
    @StateObject var modelDeletionManager = DeletionManager()
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(placementSettings)
                .environmentObject(sessionSettings)
                .environmentObject(sceneManager)
                .environmentObject(modelDeletionManager)
        }
    }
}
