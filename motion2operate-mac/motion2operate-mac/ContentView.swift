//
//  ContentView.swift
//  motion2operate-mac
//
//  Created by rei.nakaoka on 2023/08/13.
//

import SwiftUI
import motion2operate_shared

struct ContentView: View {

    @StateObject var viewModel = M2OViewModel()

    var body: some View {
        VStack {
            Text(viewModel.status)
                .font(.title)
                .padding()

            Text(viewModel.message)
                .font(.title)
                .padding()

            if let dx = viewModel.dx, let dy = viewModel.dy {
                Text("dx: \(dx)")
                Text("dy: \(dy)")

            }
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(viewModel: M2OViewModel())
    }
}

