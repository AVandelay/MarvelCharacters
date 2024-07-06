//
//  APIDataContainer.swift
//
//
//  Created by Ken Westdorp on 7/4/24.
//

import Foundation

public struct APIDataContainer: Decodable, Sendable {
    public let offset: Int
    public let limit: Int
    public let total: Int
    public let count: Int
    public let results: [Character]
}
