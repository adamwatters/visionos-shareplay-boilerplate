/**
Test implementation of RealityView for non-visionOS platforms.
 
 */

// Created by Kevin Watters on 4/22/24.

#if !os(visionOS)

import SwiftUI
import RealityKit

struct RealityViewDefaultPlaceholder : View {
    var body: some View {
        EmptyView()
    }
}

struct RealityViewEntityCollection {
    var rootNode: Entity
    
    func add(_ entity: Entity) {
        rootNode.addChild(entity)
    }
    
    func remove(_ entity: Entity) {
        rootNode.removeChild(entity)
    }
    
    var first: Entity? { rootNode.children.first }
}

struct RealityViewContent {
    
    var scene: RealityKit.Scene
    var rootAnchor: AnchorEntity
    var entities: RealityViewEntityCollection

    init(forScene: RealityKit.Scene) {
        scene = forScene
        rootAnchor = AnchorEntity(world: .zero)
        entities = .init(rootNode: self.rootAnchor)
        scene.addAnchor(rootAnchor)
    }
    
    func add(_ entity: Entity) {
        rootAnchor.addChild(entity)
    }
    
    func remove(_ entity: Entity) {
        rootAnchor.removeChild(entity)
    }
    
    public struct Body<Placeholder> : View where Placeholder : View {
        @MainActor public var body: some View {
            EmptyView()
        }
    }
}

extension TapGesture {
    func targetedToAnyEntity() -> TapGesture { self }
}

struct RealityKitView: UIViewRepresentable {
    @ObservedObject var coordinator: SceneCoordinator
    
    func makeUIView(context: Context) -> ARView {
        let view = ARView(frame: .zero, cameraMode: .nonAR, automaticallyConfigureSession: true)
        coordinator.scene = view.scene
        return view
    }

    func updateUIView(_ view: ARView, context: Context) { 
    }
}

class SceneCoordinator: ObservableObject {
    var scene: RealityKit.Scene? = nil
}

struct RealityView<Content>: View where Content: View {
    @StateObject private var coordinator = SceneCoordinator()
    
    var make: (@MainActor @Sendable (inout RealityViewContent) async -> Void)? = nil
    var update: (@MainActor (inout RealityViewContent) -> Void)? = nil
    
    var body: some View {
        RealityKitView(coordinator: coordinator)
            .onChange(of: coordinator.scene) {
                if let scene = coordinator.scene, let make {
                    Task {
                        var content = RealityViewContent(forScene: scene)
                        await make(&content)
                    }
                }
            }
    }

    
    public init(make: @escaping @MainActor @Sendable (inout RealityViewContent) async -> Void,
                update: (@MainActor (inout RealityViewContent) -> Void)? = nil)
    where Content == RealityViewContent.Body<RealityViewDefaultPlaceholder> 
    {
        self.make = make
        self.update = update
    }
}

#endif
