//
//  RandomFact.swift
//  CatRandomCombine
//
//  Created by Daniel Plata on 11/04/2020.
//  Copyright © 2020 silverapps. All rights reserved.
//

import Foundation

public struct RandomFact: Codable {
    public var _id: String?
    public var __v: Int?
    public var user: String?
    public var text: String?
    public var updatedAt: String?
    public var createdAt: String?
    public var deleted: Bool?
    public var source: Source?
    public var status: Status?
    public var used: Bool?
    public var type: String?

    public enum Source: String, Codable {
        case user
        case api
    }

    public struct Status: Codable {
        public var verified: Bool?
        public var sentCount: Int?
    }
}
