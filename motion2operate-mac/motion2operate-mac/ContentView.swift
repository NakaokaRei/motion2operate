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
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundColor(.accentColor)
            Text(viewModel.message)
        }
        .padding()
    }
}
