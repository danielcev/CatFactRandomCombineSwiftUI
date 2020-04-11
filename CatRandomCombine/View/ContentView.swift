//
//  ContentView.swift
//  CatRandomCombine
//
//  Created by Daniel Plata on 11/04/2020.
//  Copyright © 2020 silverapps. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var viewModel = RandomFactViewModel()
    var body: some View {
        VStack {
            Text(viewModel.randomText)
                .padding([.bottom, .leading, .trailing], 20)
            Button(action: {
                self.viewModel.getRandomFact()
            }) {
                Text("GET RANDOM!")
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
