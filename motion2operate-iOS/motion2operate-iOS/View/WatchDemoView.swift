//
//  WatchDemoView.swift
//  motion2operate-iOS
//
//  Created by rei.nakaoka on 2023/08/15.
//

import SwiftUI

struct WatchDemoView: View {

    @StateObject var viewModel: WatchDemoViewModel

    var body: some View {
        VStack {
            SKWatch3DView(attitude: $viewModel.attitude, multiPeerClient: viewModel.multiPeerClient)
            Text(viewModel.message)
        }
    }
}

