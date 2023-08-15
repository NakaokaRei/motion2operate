//
//  AirPodsProDemoView.swift
//  motion2operate-iOS
//
//  Created by rei.nakaoka on 2023/08/13.
//

import SwiftUI
import motion2operate_shared

struct AirPodsProDemoView: View {

    @State var number = 0
    @State var operateMode = false
    var multiPeerClient: MultipeerClient
    var cmManager: CoreMotionManager

    var body: some View {
        VStack {
            SK3DView(operateMode: $operateMode, cmManger: cmManager, multiPeerClient: multiPeerClient)
                .overlay(alignment: .top) {
                    Button("Recalibrate") {
                        cmManager.setReferenceAttitude()
                    }
                }
            Toggle("Operate Mode", isOn: $operateMode)
        }
        .padding()
    }
}
