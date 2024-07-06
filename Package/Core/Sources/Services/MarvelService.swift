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
    private let api: MarvelAPIClient
    private let errorAlert: AppState.ErrorAlert

    public init(api: MarvelAPIClient, errorAlert: AppState.ErrorAlert) {
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

    public func getCharacter(characterID: CharacterID) async throws -> Character {
        do {
            let request = MarvelAPI.CharacterRequest.Get(characterID: characterID)
            let response = try await api.execute(request)
            return response.data
        } catch {
            errorAlert.alert = .init(message: "Failed to fetch character details")
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

    public func getComicThumbnailURL(comicID: ComicID) async throws -> URL? {
        do {
            let comic = try await getComic(comicID: comicID)
            return comic.thumbnail?.fullPath
        } catch {
            errorAlert.alert = .init(message: "Failed to fetch comic thumbnail")
            throw error
        }
    }

    private func getComic(comicID: ComicID) async throws -> Comic {
        do {
            let request = MarvelAPI.ComicRequest.Get(comicID: comicID)
            let response = try await api.execute(request)
            return response.data
        } catch {
            errorAlert.alert = .init(message: "Failed to fetch comic details")
            throw error
        }
    }
}
