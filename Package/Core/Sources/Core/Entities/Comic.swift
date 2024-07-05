//
//  Comic.swift
//
//
//  Created by Ken Westdorp on 7/4/24.
//

import Foundation

public struct Comic: Decodable, Identifiable, Sendable {
    public let id: ComicID
    public let title: String
    public let description: String?
    public let thumbnail: Image?
    public let series: SeriesSummary?
    public let urls: [Url]?
    public let prices: [ComicPrice]?

    enum CodingKeys: String, CodingKey {
        case id, title, description, thumbnail, series, urls, prices
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let idValue = try container.decode(Int.self, forKey: .id)
        id = ComicID(rawValue: idValue)
        title = try container.decode(String.self, forKey: .title)
        description = try container.decodeIfPresent(String.self, forKey: .description)
        thumbnail = try container.decodeIfPresent(Image.self, forKey: .thumbnail)
        series = try container.decodeIfPresent(SeriesSummary.self, forKey: .series)
        urls = try container.decodeIfPresent([Url].self, forKey: .urls)
        prices = try container.decodeIfPresent([ComicPrice].self, forKey: .prices)
    }
}
