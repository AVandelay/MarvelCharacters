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
