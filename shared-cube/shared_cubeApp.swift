//
//  shared_cubeApp.swift
//  shared-cube
//
//  Created by Adam Watters on 4/20/24.
//

import SwiftUI

@main
struct shared_cubeApp: App {
    var body: some Scene {
        
        #if os(visionOS)
        WindowGroup {
            MenuView().glassBackgroundEffect()
        }.windowStyle(.plain)
        
        WindowGroup(id: "volume") {
            ContentView()
        }.windowStyle(.volumetric).defaultSize(width: 1, height: 1, depth: 1, in: .meters)
        #else
        WindowGroup {
            VStack {
                MenuView()
                ContentView()
            }
        }
        #endif
    }
}
