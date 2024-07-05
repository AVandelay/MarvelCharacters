//
//  Series.swift
//
//
//  Created by Ken Westdorp on 7/4/24.
//

import Foundation

public struct SeriesSummary: Decodable, Sendable {
    public let resourceURI: SeriesID
    public let name: String

    enum CodingKeys: String, CodingKey {
        case resourceURI, name
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let resourceURIValue = try container.decode(URL.self, forKey: .resourceURI)
        resourceURI = SeriesID(rawValue: resourceURIValue)
        name = try container.decode(String.self, forKey: .name)
    }
}
