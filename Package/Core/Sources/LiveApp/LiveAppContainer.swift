//
//  LiveAppContainer.swift
//
//
//  Created by Ken Westdorp on 7/5/24.
//

import Foundation
import Core
import API
import Services
import AppUI
import SwiftUI

public final class LiveAppContainer: AppContainer {
    public struct Configuration {
        let apiBaseURL: URL
        let publicKey: String
        let privateKey: String

        public init(apiBaseURL: URL, publicKey: String, privateKey: String) {
            self.apiBaseURL = apiBaseURL
            self.publicKey = publicKey
            self.privateKey = privateKey
        }
    }

    public let configuration: Configuration
    public var app: AppDependency

    private let api: MarvelAPIClient
    private let marvelService: MarvelService
    private let userDefaults: UserDefaults

    public init(configuration: Configuration) {
        self.configuration = configuration
        self.app = .init(state: .init(), actions: .init())

        self.api = MarvelAPIClient(
            session: .shared,
            configuration: .init(
                baseURL: configuration.apiBaseURL,
                publicKey: configuration.publicKey,
                privateKey: configuration.privateKey
            )
        )

        self.marvelService = MarvelService(api: api, errorAlert: app.state.errorAlert)
        self.userDefaults = .standard

        setupLiveActions()
    }

    private func setupLiveActions() {
        app.actions.characterList.loadCharacters = { [weak self] limit, offset in
            guard let self = self else { throw ErrorMessage(message: "Container was deallocated") }
            let characters = try await self.marvelService.getCharacterList(limit: limit, offset: offset)
            var loadingState = LoadingState<Int, [Character]>(input: offset)
            loadingState.state = .completed(characters)
            return loadingState
        }

        app.actions.characterList.loadMoreCharacters = { [weak self] currentCount in
            guard let self = self else { throw ErrorMessage(message: "Container was deallocated") }
            let characters = try await self.marvelService.getCharacterList(limit: 20, offset: currentCount)
            var loadingState = LoadingState<Int, [Character]>(input: currentCount)
            loadingState.state = .completed(characters)
            return loadingState
        }

        app.actions.comicListForCharacter.loadComics = { [weak self] characterID, limit, offset in
            guard let self = self else { throw ErrorMessage(message: "Container was deallocated") }
            let comics = try await self.marvelService.getComicsWithCharacter(characterID: characterID, limit: limit, offset: offset)
            var loadingState = LoadingState<Int, [Comic]>(input: offset)
            loadingState.state = .completed(comics)
            return loadingState
        }

        app.actions.comicListForCharacter.loadMoreComics = { [weak self] characterID, currentCount in
            guard let self = self else { throw ErrorMessage(message: "Container was deallocated") }
            let comics = try await self.marvelService.getComicsWithCharacter(characterID: characterID, limit: 20, offset: currentCount)
            var loadingState = LoadingState<Int, [Comic]>(input: currentCount)
            loadingState.state = .completed(comics)
            return loadingState
        }

        app.actions.characterFollowing.toggleFollowing = { [weak self] character in
            guard let self = self else { throw ErrorMessage(message: "Container was deallocated") }
            let key = "character_following_\(character.id.rawValue)"
            let newValue = !(self.userDefaults.bool(forKey: key))
            self.userDefaults.set(newValue, forKey: key)
            return newValue
        }

        app.actions.characterFollowing.isFollowing = { [weak self] characterID in
            guard let self = self else { return false }
            let key = "character_following_\(characterID.rawValue)"
            return self.userDefaults.bool(forKey: key)
        }
    }

    public func inject(content: Content) -> some View {
        content
            .dependency(app)
            .defaultAppStorage(userDefaults)
    }

    public func makeCharacterListScreenFactory() -> some CharacterListScreenFactory {
        LiveCharacterListScreenFactory()
    }

    public func makeCharacterDetailScreenFactory() -> some CharacterDetailScreenFactory {
        LiveCharacterDetailScreenFactory()
    }
}

struct LiveCharacterListScreenFactory: CharacterListScreenFactory {
    func makeScreenData(loadingState: LoadingState<Int, [Character]>) -> some CharacterListScreenData {
        LiveCharacterListScreenData(loadingState: loadingState)
    }

    func inject(content: Content) -> some View {
        content
    }
}

struct LiveCharacterListScreenData: CharacterListScreenData {
    let loadingState: LoadingState<Int, [Character]>

    var characters: [Character] {
        loadingState.value ?? []
    }

    func character(_ character: Character) -> Character {
        character
    }
}

struct LiveCharacterDetailScreenFactory: CharacterDetailScreenFactory {
    func makeScreenData(loadingState: LoadingState<Int, [Comic]>) -> some CharacterDetailScreenData {
        LiveCharacterDetailScreenData(loadingState: loadingState)
    }

    func inject(content: Content) -> some View {
        content
    }
}

struct LiveCharacterDetailScreenData: CharacterDetailScreenData {
    let loadingState: LoadingState<Int, [Comic]>

    var comics: [Comic] {
        loadingState.value ?? []
    }

    func comic(_ comic: Comic) -> Comic {
        comic
    }
}
