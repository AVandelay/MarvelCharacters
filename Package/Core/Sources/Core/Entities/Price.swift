//
//  Price.swift
//  
//
//  Created by Ken Westdorp on 7/4/24.
//

import Foundation

public struct ComicPrice: Decodable, Sendable {
    public let type: String
    public let price: Float
}
