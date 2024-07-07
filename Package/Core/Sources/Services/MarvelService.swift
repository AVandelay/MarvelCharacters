//
//  MarvelService.swift
//
//
//  Created by Ken Westdorp on 7/5/24.
//

import API
import AppUI
import Core
import Foundation

@MainActor
public final class MarvelService {
    private let api: MarvelAPIClientProtocol
    private let errorAlert: any ErrorAlertProtocol

    public init(
        api: MarvelAPIClientProtocol,
        errorAlert: any ErrorAlertProtocol
    ) {
        self.api = api
        self.errorAlert = errorAlert
    }

    public func getCharacterList(limit: Int, offset: Int) async throws -> [Character] {
        do {
            let request = MarvelAPI.CharacterListRequest.Get(limit: limit, offset: offset)
            let response = try await api.execute(request)
            return response.data.results
        } catch {
            errorAlert.alert = .init(message: "Failed to fetch character list")
            throw error
        }
    }

    public func getComicsWithCharacter(characterID: CharacterID, limit: Int, offset: Int) async throws -> [Comic] {
        do {
            let request = MarvelAPI.ComicsWithCharacterRequest.Get(characterID: characterID, limit: limit, offset: offset)
            let response = try await api.execute(request)
            return response.data.results
        } catch {
            errorAlert.alert = .init(message: "Failed to fetch comics for character")
            throw error
        }
    }
}
