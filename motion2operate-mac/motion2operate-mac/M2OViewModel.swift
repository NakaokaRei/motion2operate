//
//  M2OViewModel.swift
//  motion2operate-mac
//
//  Created by rei.nakaoka on 2023/08/13.
//

import Foundation
import motion2operate_shared
import SwiftAutoGUI

class M2OViewModel: ObservableObject {

    var multiPeerClient = MultipeerClient()

    @Published var message: String = ""

    init() {
        multiPeerClient.delegate = self
    }

    func extractDXDY(from string: String) -> (dx: Double, dy: Double)? {
        let pattern = "From iOS ([-+]?(?:\\d*\\.\\d+|\\d+)) ([-+]?(?:\\d*\\.\\d+|\\d+))"
        let regex = try! NSRegularExpression(pattern: pattern, options: [])

        if let match = regex.firstMatch(in: string, options: [], range: NSRange(location: 0, length: string.utf16.count)) {
            if let dxRange = Range(match.range(at: 1), in: string),
               let dyRange = Range(match.range(at: 2), in: string) {
                let dxString = string[dxRange]
                let dyString = string[dyRange]

                if let dx = Double(dxString), let dy = Double(dyString) {
                    return (dx, dy)
                }
            }
        }

        return nil
    }

}

extension M2OViewModel: MulitipeerProtocol {

    func recievedMessage(message: String) {
        self.message = message
        if let (dx, dy) = extractDXDY(from: message) {
            SwiftAutoGUI.moveMouse(dx: -dx, dy: -dy)
        }
    }

}

