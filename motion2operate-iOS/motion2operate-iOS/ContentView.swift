//
//  ContentView.swift
//  motion2operate-iOS
//
//  Created by rei.nakaoka on 2023/08/13.
//

import SwiftUI
import motion2operate_shared

struct ContentView: View {

    @State var number = 0
    var multiPeerClient = MultipeerClient()
    var cmManager = CoreMotionManager()

    var body: some View {
        VStack {
            SK3DView(cmManger: cmManager)
                .overlay(alignment: .top) {
                    Button("Recalibrate") {
                        cmManager.setReferenceAttitude()
                    }
                }
            Button("From iOS") {
                multiPeerClient.send(message: "From iOS \(number)")
                number += 1
            }
        }
        .padding()
    }
}
