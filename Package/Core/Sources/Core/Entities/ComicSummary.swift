//
//  ComicSummary.swift
//
//
//  Created by Ken Westdorp on 7/5/24.
//

import Foundation

public struct ComicSummary: Decodable, Sendable {
    public let resourceURI: URL
    public let name: String

    enum CodingKeys: String, CodingKey {
        case resourceURI, name
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let urlString = try container.decode(String.self, forKey: .resourceURI)
        guard let url = URL(string: urlString) else {
            throw DecodingError.dataCorruptedError(forKey: .resourceURI, in: container, debugDescription: "Invalid URL string")
        }
        self.resourceURI = url
        self.name = try container.decode(String.self, forKey: .name)
    }
}

extension ComicSummary: Equatable { }
extension ComicSummary: Hashable { }
