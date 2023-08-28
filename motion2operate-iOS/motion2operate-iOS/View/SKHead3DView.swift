//
//  SK3DView.swift
//  motion2operate-iOS
//
//  Created by rei.nakaoka on 2023/08/14.
//

import SwiftUI
import SceneKit
import motion2operate_shared
import CoreMotion

class StateWrapper {
    var lastMesseageSentAt: Date?
}

struct SKHead3DView: UIViewRepresentable {

    @State private var cubeNode: SCNNode = .init()
    @Binding var operateMode: Bool

    var cmManger: CoreMotionManager
    var multiPeerClient: MultipeerClient

    private let state = StateWrapper()
    private let messageCooldown: TimeInterval = 1.0

    func makeUIView(context: Context) -> SCNView {
        let scnView = SCNView()
        scnView.backgroundColor = .black
        scnView.allowsCameraControl = false
        scnView.showsStatistics = true

        sceneSetUp(scnView: scnView)

        cmManger.motionUpdate = { motion in
            self.nodeRotate(motion)
        }

        return scnView
    }

    func updateUIView(_ scnView: SCNView, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator {
        var parent: SKHead3DView

        init(_ parent: SKHead3DView) {
            self.parent = parent
        }

    }

    func nodeRotate(_ motion: CMDeviceMotion) {
        let data = motion.attitude
        cubeNode.eulerAngles = SCNVector3(-data.pitch, -data.yaw, -data.roll)
        if operateMode {
            updateMousePosition(using: motion)
        } else {
            computeShortcut(using: motion)
        }
    }

    func updateMousePosition(using motion: CMDeviceMotion) {
        let sensitivity: Double = 50.0 // この値を調整して、マウスの移動の感度を変更

        // ピッチとロールからマウスの移動量を計算
        let dx = motion.attitude.roll * sensitivity * 3
        let dy = motion.attitude.pitch * sensitivity

        // マウスを移動
        multiPeerClient.send(message: "moveMouse \(dx) \(dy)")
    }

    func computeShortcut(using motion: CMDeviceMotion) {
        let yawThreshold: Double = .pi / 6

        if let lastSent = state.lastMesseageSentAt, Date().timeIntervalSince(lastSent) < messageCooldown {
            return
        }

        if motion.attitude.yaw > yawThreshold {
            multiPeerClient.send(message: "turn left")
            state.lastMesseageSentAt = Date()
        } else if motion.attitude.yaw < -yawThreshold {
            multiPeerClient.send(message: "turn right")
            state.lastMesseageSentAt = Date()
        }
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

        // Adding a cube(face) to a scene
        let cube: SCNGeometry = SCNBox(width: 3, height: 3, length: 3, chamferRadius: 0.5)
        let eye: SCNGeometry = SCNSphere(radius: 0.3)
        let leftEye = SCNNode(geometry: eye)
        let rightEye = SCNNode(geometry: eye)
        leftEye.position = SCNVector3(x: 0.6, y: 0.6, z: 1.5)
        rightEye.position = SCNVector3(x: -0.6, y: 0.6, z: 1.5)

        let nose: SCNGeometry = SCNSphere(radius: 0.3)
        let noseNode = SCNNode(geometry: nose)
        noseNode.position = SCNVector3(x: 0, y: 0, z: 1.5)

        let mouth: SCNGeometry = SCNBox(width: 1.5, height: 0.2, length: 0.2, chamferRadius: 0.4)
        let mouthNode = SCNNode(geometry: mouth)
        mouthNode.position = SCNVector3(x: 0, y: -0.6, z: 1.5)

        DispatchQueue.main.async {
            cubeNode = SCNNode(geometry: cube)
            cubeNode.addChildNode(leftEye)
            cubeNode.addChildNode(rightEye)
            cubeNode.addChildNode(noseNode)
            cubeNode.addChildNode(mouthNode)
            cubeNode.position = SCNVector3(x: 0, y: 0, z: 0)

            scene.rootNode.addChildNode(cubeNode)
        }
    }
}

