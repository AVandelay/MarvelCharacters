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
        return URL(string: "\(path.absoluteString).\(`extension`)")
    }

    enum CodingKeys: String, CodingKey {
        case path
        case `extension` = "extension"
    }
}

extension Image: Equatable { }
extension Image: Hashable { }
