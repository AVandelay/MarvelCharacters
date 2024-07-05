//
//  MarvelAPIClient.swift
//
//
//  Created by Ken Westdorp on 7/4/24.
//

import Foundation
import Core

public final class MarvelAPIClient: Sendable {
    public struct Configuration: Sendable {
        let baseURL: URL
        let publicKey: String
        let privateKey: String

        public init(baseURL: URL, publicKey: String, privateKey: String) {
            self.baseURL = baseURL
            self.publicKey = publicKey
            self.privateKey = privateKey
        }
    }

    let session: URLSession
    let configuration: Configuration

    public init(session: URLSession, configuration: Configuration) {
        self.session = session
        self.configuration = configuration
    }

    public func execute<Request: MarvelAPIRequest>(_ request: Request) async throws -> Request.Response {
        let (data, _) = try await session.data(for: request.makeURLRequest(configuration: configuration))
        return try request.decode(data: data)
    }
}
