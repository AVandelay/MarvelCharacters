//
//  MarvelAPIResponse.swift
//
//
//  Created by Ken Westdorp on 7/4/24.
//

import Foundation

public struct MarvelAPIResponse<Message: Sendable & Decodable>: Sendable, Decodable {
    public let data: Message
    public let status: String
}
