//
//  CatFactApi.swift
//  CatRandomCombine
//
//  Created by Daniel Plata on 11/04/2020.
//  Copyright © 2020 silverapps. All rights reserved.
//

import Foundation
import Combine

public class CatFactApi: CatFactProvider {
    private let baseURL = "https://cat-fact.herokuapp.com"
    private enum Endpoint: String {
        case random = "/facts/random"
    }
    private enum Method: String {
        case GET
    }

    public init() {}

    // MARK: Traditional

    public func randomFact(completion: @escaping((Result<RandomFact, APIError>) -> Void)) {
        request(endpoint: .random, method: .GET, completion: completion)
    }

    private func request<T: Codable>(endpoint: Endpoint, method: Method,
                                  completion: @escaping((Result<T, APIError>) -> Void)) {
        let path = "\(baseURL)\(endpoint.rawValue)"
        guard let url = URL(string: path)
            else { completion(.failure(.internalError)); return }

        var request = URLRequest(url: url)
        request.httpMethod = "\(method)"
        request.allHTTPHeaderFields = ["Content-Type": "application/json"]

        call(with: request, completion: completion)
    }

    private func call<T: Codable>(with request: URLRequest,
                                  completion: @escaping((Result<T, APIError>) -> Void)) {
        let dataTask = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard error == nil
                else { completion(.failure(.serverError)); return }
            do {
                guard let data = data
                    else { completion(.failure(.serverError)); return }
                let object = try JSONDecoder().decode(T.self, from: data)
                completion(Result.success(object))
            } catch {
                completion(Result.failure(.parsingError))
            }
        }
        dataTask.resume()
    }

    // MARK: Combine

    public func randomFact() -> AnyPublisher<RandomFact, APIError> {
        return call(.random, method: .GET)
    }

    private func call<T: Codable>(_ endPoint: Endpoint, method: Method) -> AnyPublisher<T, APIError> {
        let urlRequest = request(for: endPoint, method: method)

        return URLSession.shared.dataTaskPublisher(for: urlRequest)
            .mapError{ _ in APIError.serverError }
            .map { $0.data }
            .decode(type: T.self, decoder: JSONDecoder())
            .mapError { _ in APIError.parsingError }
            .eraseToAnyPublisher()
    }

    private func request(for endpoint: Endpoint, method: Method) -> URLRequest {
        let path = "\(baseURL)\(endpoint.rawValue)"
        guard let url = URL(string: path)
            else { preconditionFailure("Bad URL") }

        var request = URLRequest(url: url)
        request.httpMethod = "\(method)"
        request.allHTTPHeaderFields = ["Content-Type": "application/json"]
        return request
    }
}
