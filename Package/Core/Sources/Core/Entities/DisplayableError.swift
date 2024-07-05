//
//  DisplayableError.swift
//
//
//  Created by Ken Westdorp on 7/5/24.
//

import Foundation

public struct DisplayableError: Identifiable, LocalizedError {
    public let id: UUID = .init()

    public let underlying: (any Error)?

    public let message: String

    public init(underlying: (any Error)? = nil, message: String) {
        self.underlying = underlying
        self.message = message
    }

    public var errorDescription: String? {
        message
    }
}
