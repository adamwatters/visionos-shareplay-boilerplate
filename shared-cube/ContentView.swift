//
//  ContentView.swift
//  shared-cube
//
//  Created by Adam Watters on 4/20/24.
//

import SwiftUI
import RealityKit
import GroupActivities

struct ContentView: View {
    @StateObject private var groupStateObserver = GroupStateObserver()
    @State private var enlarge = false

    var body: some View {
        RealityView { content in
            let cube = ModelEntity(mesh: MeshResource.generateBox(size: 0.5, cornerRadius: 0.1))
            var material = PhysicallyBasedMaterial()
            material.baseColor = .init(tint: .green)
            cube.model?.materials = [material]
            content.add(cube)
        } update: { content in
            // Update the RealityKit content when SwiftUI state changes
            if let scene = content.entities.first {
                let uniformScale: Float = enlarge ? 1.4 : 1.0
                scene.transform.scale = [uniformScale, uniformScale, uniformScale]
            }
        }
        .gesture(TapGesture().targetedToAnyEntity().onEnded { _ in
            enlarge.toggle()
        })
        .toolbar {
            ToolbarItemGroup(placement: toolbarPlacement) {
                VStack (spacing: 12) {
                    Toggle("Enlarge RealityView Content", isOn: $enlarge)
                }
            }
        }
        
        var toolbarPlacement: ToolbarItemPlacement {
            #if os(visionOS)
            .bottomOrnament
            #else
            .automatic
            #endif
        }
    }
}

#if os(visionOS)
#Preview(windowStyle: .volumetric) {
    ContentView()
}
#else
#Preview {
    ContentView()
}
#endif
