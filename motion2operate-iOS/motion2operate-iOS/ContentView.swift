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

    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundColor(.accentColor)
            Button("From iOS") {
                multiPeerClient.send(message: "From iOS \(number)")
                number += 1
            }
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
