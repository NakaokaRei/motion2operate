//
//  WatchDemoViewModel.swift
//  motion2operate-iOS
//
//  Created by rei.nakaoka on 2023/08/15.
//

import Foundation
import motion2operate_shared
import WatchConnectivity

class WatchDemoViewModel: NSObject, ObservableObject {

    @Published var message: String = ""
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


}

extension WatchDemoViewModel: WCSessionDelegate {

    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        // send to mac app
        let message = message["message"] as! String
        self.message = message
        multiPeerClient.send(message: message)
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
