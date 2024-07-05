//
//  Comic.swift
//
//
//  Created by Ken Westdorp on 7/4/24.
//

import Foundation

public struct Comic: Decodable, Sendable {
    public let resourceURI: ComicID
    public let name: String

    enum CodingKeys: String, CodingKey {
        case resourceURI, name
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let resourceURIValue = try container.decode(URL.self, forKey: .resourceURI)
        resourceURI = ComicID(value: resourceURIValue)
        name = try container.decode(String.self, forKey: .name)
    }
}
