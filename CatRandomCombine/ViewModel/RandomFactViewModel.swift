//
//  RandomFactViewModel.swift
//  CatRandomCombine
//
//  Created by Daniel Plata on 11/04/2020.
//  Copyright © 2020 silverapps. All rights reserved.
//
import SwiftUI
import Combine
import Foundation

final class RandomFactViewModel: ObservableObject {
    @Published var randomText: String
    private var apiProvider: CatFactProvider
    private var publishers = [AnyCancellable]()

    init() {
        randomText = ""
        apiProvider = CatFactApi()
    }

    func getRandomFact() {
        apiProvider
            .randomFact()
            .map { $0.text }
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { error in
                print(error)
            }) { value in
                self.randomText = value ?? ""
            }
            .store(in: &publishers)

    }
}
