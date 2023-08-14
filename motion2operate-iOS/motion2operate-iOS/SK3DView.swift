//
//  SK3DView.swift
//  motion2operate-iOS
//
//  Created by rei.nakaoka on 2023/08/14.
//

import SwiftUI
import SceneKit
import CoreMotion

struct SK3DView: UIViewRepresentable {
    @State private var cubeNode: SCNNode = .init()
    private var cmManger = CoreMotionManager()

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
        var parent: SK3DView

        init(_ parent: SK3DView) {
            self.parent = parent
        }

    }

    func nodeRotate(_ motion: CMDeviceMotion) {
        let data = motion.attitude
        cubeNode.eulerAngles = SCNVector3(-data.pitch, -data.yaw, -data.roll)
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

