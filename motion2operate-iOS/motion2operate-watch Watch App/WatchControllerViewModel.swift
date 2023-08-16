//
//  WatchControllerViewModel.swift
//  motion2operate-watch Watch App
//
//  Created by rei.nakaoka on 2023/08/15.
//

import Foundation
import WatchConnectivity
import CoreMotion

class WatchControllerViewModel: NSObject, ObservableObject {

    private let motionManager = CMMotionManager()
    private var referenceAttitude: CMAttitude? = nil

    override init() {
        super.init()
        if WCSession.isSupported() {
            let session = WCSession.default
            session.delegate = self
            session.activate()
        }

        motionManager.startDeviceMotionUpdates(to: OperationQueue.current!) { [weak self] motion, error in
            if let motion = motion, error == nil {
                if let reference = self?.referenceAttitude {
                    motion.attitude.multiply(byInverseOf: reference)
                }
                self?.send(motion: motion)
            }
        }
    }

    func send(message: String) {
        WCSession.default.sendMessage(["message": message], replyHandler: nil, errorHandler: nil)
    }

    private func send(motion: CMDeviceMotion) {
        let attitudeString = "pitch \(motion.attitude.pitch), roll \(motion.attitude.roll), yaw \(motion.attitude.yaw)"
        WCSession.default.sendMessage(["attitude": attitudeString], replyHandler: nil, errorHandler: nil)
    }

    func setReferenceAttitude() {
        referenceAttitude = motionManager.deviceMotion?.attitude
    }

    func stopUpdates() {
        motionManager.stopDeviceMotionUpdates()
    }

}

extension WatchControllerViewModel: WCSessionDelegate {

    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        // TODO
    }

}
