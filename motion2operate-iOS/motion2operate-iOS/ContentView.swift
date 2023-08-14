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
            SK3DView(cmManger: cmManager, multiPeerClient: multiPeerClient)
                .overlay(alignment: .top) {
                    Button("Recalibrate") {
                        cmManager.setReferenceAttitude()
                    }
                }
        }
        .padding()
    }
}
