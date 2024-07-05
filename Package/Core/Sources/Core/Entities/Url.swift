//
//  Url.swift
//  
//
//  Created by Ken Westdorp on 7/4/24.
//

import Foundation

public struct Url: Decodable, Sendable {
    public let type: String
    public let url: URL
}
