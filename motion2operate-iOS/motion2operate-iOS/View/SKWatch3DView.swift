//
//  SKWatch3DView.swift
//  motion2operate-iOS
//
//  Created by rei.nakaoka on 2023/08/16.
//

import SwiftUI
import SceneKit
import motion2operate_shared
import CoreMotion

struct SKWatch3DView: UIViewRepresentable {

    @State private var watchNode: SCNNode = .init()
    @Binding var attitude: WatchAttitude?

    var multiPeerClient: MultipeerClient

    func makeUIView(context: Context) -> SCNView {
        let scnView = SCNView()
        scnView.backgroundColor = .black
        scnView.allowsCameraControl = false
        scnView.showsStatistics = true

        sceneSetUp(scnView: scnView)

        return scnView
    }

    func updateUIView(_ scnView: SCNView, context: Context) {
        if let attitude = attitude {
            nodeRotate(attitude)
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator {
        var parent: SKWatch3DView

        init(_ parent: SKWatch3DView) {
            self.parent = parent
        }

    }

    func nodeRotate(_ attitude: WatchAttitude) {
        // Apple Watchの向きに合わせて回転値を調整
        watchNode.eulerAngles = SCNVector3(-attitude.roll, attitude.yaw, -attitude.pitch)
//        updateMousePosition(using: attitude)
    }

    func updateMousePosition(using attitude: WatchAttitude) {
        let sensitivity: Double = 3.0 // この値を調整して、マウスの移動の感度を変更

        // ピッチとロールからマウスの移動量を計算
        let dx = attitude.pitch * sensitivity
        let dy = -attitude.roll * sensitivity

        // マウスを移動
        multiPeerClient.send(message: "moveMouse \(dx) \(dy)")
    }

    func sceneSetUp(scnView: SCNView) {
        scnView.frame = UIScreen.main.bounds
        scnView.backgroundColor = UIColor.black
        scnView.allowsCameraControl = false
        scnView.showsStatistics = true

        // Set SCNScene to SCNView
        let scene = SCNScene()
        scnView.scene = scene

        // Adding a camera to a scene
        let cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        cameraNode.position = SCNVector3(x: 0, y: 0, z: 15)
        scene.rootNode.addChildNode(cameraNode)

        // Adding an omnidirectional light source to the scene
        let omniLight = SCNLight()
        omniLight.type = .omni
        let omniLightNode = SCNNode()
        omniLightNode.light = omniLight
        omniLightNode.position = SCNVector3(x: 0, y: 10, z: 10)
        scene.rootNode.addChildNode(omniLightNode)

        // Adding a light source to your scene that illuminates from all directions.
        let ambientLight = SCNLight()
        ambientLight.type = .ambient
        ambientLight.color = UIColor.darkGray
        let ambientLightNode = SCNNode()
        ambientLightNode.light = ambientLight
        scene.rootNode.addChildNode(ambientLightNode)

        // Adding a watch-like shape to a scene
        let watch: SCNGeometry = SCNBox(width: 3, height: 0.5, length: 2, chamferRadius: 0.2)
        DispatchQueue.main.async {
            watchNode = SCNNode(geometry: watch)
            watchNode.position = SCNVector3(x: 0, y: 0, z: 0)
            scene.rootNode.addChildNode(watchNode)
        }
    }
}


