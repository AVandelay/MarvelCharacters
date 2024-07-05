//
//  CharacterListRequest.swift
//  
//
//  Created by Ken Westdorp on 7/4/24.
//

import Foundation
import Core

extension MarvelAPI {
    public enum CharacterListRequest {
        public struct Get: MarvelAPIRequest {
            public typealias Message = [Character]

            public let path = "v1/public/characters"
            public let method = "GET"
            public let limit: Int
            public let offset: Int

            public init(limit: Int, offset: Int) {
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
