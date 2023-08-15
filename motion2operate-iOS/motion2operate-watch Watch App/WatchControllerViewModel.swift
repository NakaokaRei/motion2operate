//
//  WatchControllerViewModel.swift
//  motion2operate-watch Watch App
//
//  Created by rei.nakaoka on 2023/08/15.
//

import Foundation
import WatchConnectivity

class WatchControllerViewModel: NSObject, ObservableObject {

    override init() {
        super.init()
        if WCSession.isSupported() {
            let session = WCSession.default
            session.delegate = self
            session.activate()
        }
    }

    func send(message: String) {
        WCSession.default.sendMessage(["message": message], replyHandler: nil, errorHandler: nil)
    }

}

extension WatchControllerViewModel: WCSessionDelegate {

    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        // TODO
    }

}
