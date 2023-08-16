//
//  WatchDemoViewModel.swift
//  motion2operate-iOS
//
//  Created by rei.nakaoka on 2023/08/15.
//

import Foundation
import motion2operate_shared
import WatchConnectivity
import CoreMotion

struct WatchAttitude {
    var pitch: Double
    var roll: Double
    var yaw: Double
}

class WatchDemoViewModel: NSObject, ObservableObject {

    @Published var message: String = ""
    @Published var attitude: WatchAttitude? = nil

    var multiPeerClient: MultipeerClient

    init(mutliPeerClient: MultipeerClient) {
        self.multiPeerClient = mutliPeerClient

        super.init()
        if WCSession.isSupported() {
            let session = WCSession.default
            session.delegate = self
            session.activate()
        }
    }

    func extractAttitude(from string: String) -> WatchAttitude? {
        let patterns = ["pitch ([\\-\\.\\d]+)", "roll ([\\-\\.\\d]+)", "yaw ([\\-\\.\\d]+)"]

        var pitch: Double?
        var roll: Double?
        var yaw: Double?

        for pattern in patterns {
            if let regex = try? NSRegularExpression(pattern: pattern, options: []),
               let match = regex.firstMatch(in: string, options: [], range: NSRange(location: 0, length: string.count)),
               let range = Range(match.range(at: 1), in: string) {

                let value = Double(string[range])
                if pattern.contains("pitch") {
                    pitch = value
                } else if pattern.contains("roll") {
                    roll = value
                } else if pattern.contains("yaw") {
                    yaw = value
                }
            }
        }

        if let pitch = pitch, let roll = roll, let yaw = yaw {
            return .init(pitch: pitch, roll: roll, yaw: yaw)
        }

        return nil
    }
}

extension WatchDemoViewModel: WCSessionDelegate {

    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        // send to mac app
        if let message = message["message"] as? String {
            self.message = message
            multiPeerClient.send(message: message)
        } else if let attitude = extractAttitude(from: message["attitude"] as! String) {
            DispatchQueue.main.async {
                self.attitude = attitude
            }
        }
    }

    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        // TODO
    }

    func sessionDidBecomeInactive(_ session: WCSession) {
        // TODO
    }

    func sessionDidDeactivate(_ session: WCSession) {
        // TODO
    }

}
