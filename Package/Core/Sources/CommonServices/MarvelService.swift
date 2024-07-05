//
//  MarvelService.swift
//
//
//  Created by Ken Westdorp on 7/5/24.
//

import API
import Core
import Foundation

@MainActor
public final class MarvelService {
    private let api: MarvelAPIClient

    public init(api: MarvelAPIClient) {
        self.api = api
    }

    public func getCharacterList(limit: Int, offset: Int) async throws -> [Character] {
        let request = MarvelAPI.CharacterListRequest.Get(limit: limit, offset: offset)
        let response = try await api.execute(request)
        return response.data
    }

    public func getCharacter(characterID: CharacterID) async throws -> Character {
        let request = MarvelAPI.CharacterRequest.Get(characterID: characterID)
        let response = try await api.execute(request)
        return response.data
    }

    public func getComicsWithCharacter(characterID: CharacterID, limit: Int, offset: Int) async throws -> [Comic] {
        let request = MarvelAPI.ComicsWithCharacterRequest.Get(characterID: characterID, limit: limit, offset: offset)
        let response = try await api.execute(request)
        return response.data
    }

    public func getComicThumbnailURL(comicID: ComicID) async throws -> URL? {
        let comic = try await getComic(comicID: comicID)
        return comic.thumbnail?.fullPath
    }

    private func getComic(comicID: ComicID) async throws -> Comic {
        let request = MarvelAPI.ComicRequest.Get(comicID: comicID)
        let response = try await api.execute(request)
        return response.data
    }
}


