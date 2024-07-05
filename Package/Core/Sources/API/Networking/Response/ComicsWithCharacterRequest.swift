//
//  ComicsWithCharacterRequest.swift
//
//
//  Created by Ken Westdorp on 7/4/24.
//

import Foundation
import Core

extension MarvelAPI {
    public enum ComicsWithCharacterRequest {
        public struct Get: MarvelAPIRequest {
            public typealias Message = [Comic]

            public var path: String { "v1/public/characters/\(characterID.rawValue)/comics" }
            public let method = "GET"
            public let characterID: CharacterID
            public let limit: Int
            public let offset: Int

            public init(characterID: CharacterID, limit: Int, offset: Int) {
                self.characterID = characterID
                self.limit = limit
                self.offset = offset
            }

            public var queryItems: [URLQueryItem] {
                return [
                    URLQueryItem(name: "limit", value: "\(limit)"),
                    URLQueryItem(name: "offset", value: "\(offset)")
                ]
            }
        }
    }
}
