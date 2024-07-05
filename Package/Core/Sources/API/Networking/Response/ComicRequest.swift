//
//  ComicRequest.swift
//
//
//  Created by Ken Westdorp on 7/5/24.
//

import Foundation
import Core

extension MarvelAPI {
    public enum ComicRequest {
        public struct Get: MarvelAPIRequest {
            public typealias Message = Comic

            public var path: String { "v1/public/comics/\(comicID.rawValue)" }
            public let method = "GET"
            public let comicID: ComicID

            public init(comicID: ComicID) {
                self.comicID = comicID
            }

            public var queryItems: [URLQueryItem] {
                return []
            }
        }
    }
}
