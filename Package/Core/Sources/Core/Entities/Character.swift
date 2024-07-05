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
    public let thumbnail: Image?
    public let comics: CollectionResource<Comic>
    public var isFollowing: Bool = false

    enum CodingKeys: String, CodingKey {
        case id, name, description, thumbnail, comics
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let idValue = try container.decode(Int.self, forKey: .id)
        id = CharacterID(rawValue: idValue)
        name = try container.decode(String.self, forKey: .name)
        description = try container.decodeIfPresent(String.self, forKey: .description)
        thumbnail = try container.decodeIfPresent(Image.self, forKey: .thumbnail)
        comics = try container.decode(CollectionResource<Comic>.self, forKey: .comics)
    }
}

extension Character: Equatable { }
extension Character: Hashable { }
