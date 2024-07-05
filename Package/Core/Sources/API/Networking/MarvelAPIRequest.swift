//
//  MarvelAPIRequest.swift
//
//
//  Created by Ken Westdorp on 7/4/24.
//

import Foundation
import CryptoKit

public protocol MarvelAPIRequest: Sendable {
    associatedtype Message: Decodable & Sendable

    typealias Response = MarvelAPIResponse<Message>

    var path: String { get }

    var method: String { get }

    var queryItems: [URLQueryItem] { get }

    func makeURLRequest(configuration: MarvelAPIClient.Configuration) throws -> URLRequest

    func decode(data: Data) throws -> Response
}

extension MarvelAPIRequest {
    public func makeURLRequest(configuration: MarvelAPIClient.Configuration) throws -> URLRequest {
        guard let baseURL = URL(string: configuration.baseURL.absoluteString) else {
            throw URLError(.badURL)
        }

        let timestamp = "\(Date().timeIntervalSince1970)"
        let hash = MD5(string: timestamp + configuration.privateKey + configuration.publicKey)
        let url = baseURL.appendingPathComponent(path)
        guard var components = URLComponents(url: url, resolvingAgainstBaseURL: false) else {
            throw URLError(.badURL)
        }

        components.queryItems = [
            URLQueryItem(name: "apikey", value: configuration.publicKey),
            URLQueryItem(name: "ts", value: timestamp),
            URLQueryItem(name: "hash", value: hash)
        ] + queryItems

        guard let finalURL = components.url else {
            throw URLError(.badURL)
        }

        var request = URLRequest(url: finalURL)
        request.httpMethod = method
        return request
    }

    public func decode(data: Data) throws -> Response {
        try JSONDecoder().decode(Response.self, from: data)
    }

    private func MD5(string: String) -> String {
        let digest = Insecure.MD5.hash(data: string.data(using: .utf8) ?? Data())
        return digest.map { String(format: "%02hhx", $0) }.joined()
    }
}
