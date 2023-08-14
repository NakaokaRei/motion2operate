//
//  CoreMotionManager.swift
//  motion2operate-iOS
//
//  Created by rei.nakaoka on 2023/08/14.
//

import Foundation
import CoreMotion

class CoreMotionManager: NSObject, ObservableObject {

    private let motionManager = CMHeadphoneMotionManager()
    private var referenceAttitude: CMAttitude? = nil
    var motionUpdate: ((CMDeviceMotion) -> Void)?

    override init() {
        super.init()
        motionManager.delegate = self

        guard motionManager.isDeviceMotionAvailable else { return }

        motionManager.startDeviceMotionUpdates(to: OperationQueue.current!) { [weak self] motion, error in
            if let motion = motion, error == nil {
                if let reference = self?.referenceAttitude {
                    motion.attitude.multiply(byInverseOf: reference)
                }
                self?.motionUpdate?(motion)
            }
        }
    }

    func setReferenceAttitude() {
        referenceAttitude = motionManager.deviceMotion?.attitude
    }

    func stopUpdates() {
        motionManager.stopDeviceMotionUpdates()
    }
}

extension CoreMotionManager: CMHeadphoneMotionManagerDelegate {}
