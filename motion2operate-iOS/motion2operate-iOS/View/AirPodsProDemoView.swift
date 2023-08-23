//
//  AirPodsProDemoView.swift
//  motion2operate-iOS
//
//  Created by rei.nakaoka on 2023/08/13.
//

import SwiftUI
import motion2operate_shared

struct AirPodsProDemoView: View {

    @State var operateMode = false
    var multiPeerClient: MultipeerClient
    var cmManager: CoreMotionManager

    var body: some View {
        VStack {
            SKHead3DView(operateMode: $operateMode, cmManger: cmManager, multiPeerClient: multiPeerClient)
                .overlay(alignment: .topTrailing) {
                    HStack {
                        Toggle("Operate Mode", isOn: $operateMode)
                        Button(action: {
                            cmManager.setReferenceAttitude()
                        }) {
                            Image(systemName: "arrow.counterclockwise.circle.fill")
                                .resizable()
                                .frame(width: 30, height: 30)
                                .foregroundColor(.accentColor)
                                .padding()
                        }
                    }
                }
        }
        .padding()
    }
}
