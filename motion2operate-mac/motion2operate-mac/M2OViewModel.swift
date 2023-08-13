//
//  M2OViewModel.swift
//  motion2operate-mac
//
//  Created by rei.nakaoka on 2023/08/13.
//

import Foundation
import motion2operate_shared

class M2OViewModel: ObservableObject {

    var multiPeerClient = MultipeerClient()

    @Published var message: String = ""

    init() {
        multiPeerClient.delegate = self
    }

}

extension M2OViewModel: MulitipeerProtocol {

    func recievedMessage(message: String) {
        self.message = message
    }

}

