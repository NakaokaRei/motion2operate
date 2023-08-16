//
//  WatchControllerView.swift
//  motion2operate-watch Watch App
//
//  Created by rei.nakaoka on 2023/08/15.
//

import SwiftUI

struct WatchControllerView: View {

    @StateObject var viewModel = WatchControllerViewModel()
    @State var number = 0


    var body: some View {
        VStack {
            Button("send to iOS to Mac") {
                viewModel.send(message: "from Watch \(number)")
                number += 1
            }
            Button("set reference") {
                viewModel.setReferenceAttitude()
            }
        }
    }
}

