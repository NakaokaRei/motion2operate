//
//  CoreMotionManager.swift
//  motion2operate-iOS
//
//  Created by rei.nakaoka on 2023/08/14.
//

import Foundation
import CoreMotion

class CoreMotionManager: NSObject {

    private let motionManager = CMHeadphoneMotionManager()
    var motionUpdate: ((CMDeviceMotion) -> Void)?

    override init() {
        super.init()
        motionManager.delegate = self

        guard motionManager.isDeviceMotionAvailable else { return }

        motionManager.startDeviceMotionUpdates(to: OperationQueue.current!) { [weak self] motion, error in
            if let motion = motion, error == nil {
                self?.motionUpdate?(motion)
            }
        }
    }

    func stopUpdates() {
        motionManager.stopDeviceMotionUpdates()
    }
}

extension CoreMotionManager: CMHeadphoneMotionManagerDelegate {}
