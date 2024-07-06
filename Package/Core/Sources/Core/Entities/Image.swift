//
//  Image.swift
//
//
//  Created by Ken Westdorp on 7/4/24.
//

import Foundation

public struct Image: Decodable, Sendable {
    public let path: URL
    public let `extension`: String

    public var fullPath: URL? {
        var components = URLComponents(url: path, resolvingAgainstBaseURL: false)
        components?.scheme = "https"
        guard let secureURL = components?.url else { return nil }
        return URL(string: "\(secureURL.absoluteString).\(`extension`)")
    }

    enum CodingKeys: String, CodingKey {
        case path
        case `extension` = "extension"
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let pathString = try container.decode(String.self, forKey: .path)
        guard var components = URLComponents(string: pathString) else {
            throw DecodingError.dataCorruptedError(forKey: .path, in: container, debugDescription: "Invalid URL string")
        }
        components.scheme = "https"
        guard let secureURL = components.url else {
            throw DecodingError.dataCorruptedError(forKey: .path, in: container, debugDescription: "Unable to create secure URL")
        }
        self.path = secureURL
        self.extension = try container.decode(String.self, forKey: .extension)
    }
}

extension Image: Equatable { }
extension Image: Hashable { }
