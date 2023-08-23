//
//  RootView.swift
//  motion2operate-iOS
//
//  Created by rei.nakaoka on 2023/08/15.
//

import SwiftUI
import motion2operate_shared

struct RootView: View {

    var multiPeerClient = MultipeerClient()
    var cmManager = CoreMotionManager()

    var body: some View {
        AirPodsProDemoView(multiPeerClient: multiPeerClient, cmManager: cmManager)
//        TabView {
//            AirPodsProDemoView(multiPeerClient: multiPeerClient, cmManager: cmManager)
//                .tabItem {
//                    Image(systemName: "airpodspro")
//                    Text("AirPods Pro")
//                }
//            WatchDemoView(viewModel: .init(mutliPeerClient: multiPeerClient))
//                .tabItem {
//                    Image(systemName: "applewatch")
//                    Text("Watch")
//                }
//        }
    }
}
