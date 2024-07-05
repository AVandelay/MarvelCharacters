//
//  CharacterRequest.swift
//
//
//  Created by Ken Westdorp on 7/4/24.
//

import Foundation
import Core

extension MarvelAPI {
    public enum CharacterRequest {
        public struct Get: MarvelAPIRequest {
            public typealias Message = Character

            public var path: String { "v1/public/characters/\(characterID.rawValue)" }
            public let method = "GET"
            public let characterID: CharacterID

            public init(characterID: CharacterID) {
                self.characterID = characterID
            }

            public var queryItems: [URLQueryItem] {
                return []
            }
        }
    }
}
