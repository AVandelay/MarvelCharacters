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
    public let thumbnail: Image?
    public let issueNumber: Double?

    public var formattedIssueNumber: String? {
        guard let issueNumber = issueNumber else { return nil }
        return String(format: "#%.1f", issueNumber)
    }

    enum CodingKeys: String, CodingKey {
        case id, title, thumbnail, issueNumber
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let idValue = try container.decode(Int.self, forKey: .id)
        id = ComicID(rawValue: idValue)
        title = try container.decode(String.self, forKey: .title)
        thumbnail = try container.decodeIfPresent(Image.self, forKey: .thumbnail)
        issueNumber = try container.decodeIfPresent(Double.self, forKey: .issueNumber)
    }
}

extension Comic: Equatable { }

extension Comic: Hashable { }
