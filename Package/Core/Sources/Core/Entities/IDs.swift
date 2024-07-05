//
//  Tagged.swift
//
//
//  Created by Ken Westdorp on 7/4/24.
//

import Foundation

public struct CharacterID: Equatable, Hashable, Codable, Sendable {
    public let rawValue: Int
    public init(rawValue: Int) {
        self.rawValue = rawValue
    }
}

public struct ComicID: Equatable, Hashable, Codable, Sendable {
    public let rawValue: Int
    public init(rawValue: Int) {
        self.rawValue = rawValue
    }
}

public struct SeriesID: Equatable, Hashable, Codable, Sendable {
    public let rawValue: URL
    public init(rawValue: URL) {
        self.rawValue = rawValue
    }
}
