//
//  Character.swift
//
//
//  Created by Ken Westdorp on 7/4/24.
//

import Foundation

public struct Character: Decodable, Identifiable, Sendable {
    public let id: CharacterID
    public let name: String
    public let description: String?
    public let thumbnail: ImageResource
    public let comics: CollectionResource<Comic>

    enum CodingKeys: String, CodingKey {
        case id, name, description, thumbnail, comics
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let idValue = try container.decode(Int.self, forKey: .id)
        id = CharacterID(value: idValue)
        name = try container.decode(String.self, forKey: .name)
        description = try container.decodeIfPresent(String.self, forKey: .description)
        thumbnail = try container.decode(ImageResource.self, forKey: .thumbnail)
        comics = try container.decode(CollectionResource<Comic>.self, forKey: .comics)
    }
}
