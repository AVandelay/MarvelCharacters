//
//  CollectionResource.swift
//
//
//  Created by Ken Westdorp on 7/4/24.
//

import Foundation

public struct CollectionResource<T: Decodable & Sendable>: Decodable, Sendable {
    public let available: Int
    public let items: [T]
}

extension CollectionResource: Equatable where T: Equatable {
    public static func == (lhs: CollectionResource<T>, rhs: CollectionResource<T>) -> Bool {
        return lhs.available == rhs.available && lhs.items == rhs.items
    }
}

extension CollectionResource: Hashable where T: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(available)
        hasher.combine(items)
    }
}
