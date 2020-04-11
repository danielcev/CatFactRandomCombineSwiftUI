//
//  CatFactProvider.swift
//  CatRandomCombine
//
//  Created by Daniel Plata on 11/04/2020.
//  Copyright © 2020 silverapps. All rights reserved.
//

import Combine

public enum APIError: Error {
    case internalError
    case serverError
    case parsingError
}

public protocol CatFactProvider {
    func randomFact(completion: @escaping((Result<RandomFact, APIError>) -> Void))
    // MARK: Combine
    func randomFact() -> AnyPublisher<RandomFact, APIError>
}
