//
//  APIResponse.swift
//  
//
//  Created by Ken Westdorp on 7/4/24.
//

import Foundation

public struct APIResponse<T: Decodable & Sendable>: Decodable, Sendable {
    public let code: Int
    public let status: String
    public let data: APIDataContainer<T>
}
