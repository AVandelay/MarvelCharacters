//
//  MockAppContainer.swift
//
//
//  Created by Ken Westdorp on 7/5/24.
//

import Core
import SwiftUI

public final class MockAppContainer: MockDependencyContainer, AppContainer {
    public struct Configuration {
        var characters: [Character]
        var comics: [Comic]
        var didShowWelcome: Bool

        public init(
            characters: [Character] = [],
            comics: [Comic] = [],
            didShowWelcome: Bool = true
        ) {
            self.characters = characters
            self.comics = comics
            self.didShowWelcome = didShowWelcome
        }
    }

    public let configuration: Configuration
    public var app: AppDependency
    let defaults: UserDefaults

    public init(configuration: Configuration) {
        self.configuration = configuration
        self.app = .init(state: .init(), actions: .init())
        self.defaults = .mock()

        setupMockActions()
        defaults.set(configuration.didShowWelcome, forKey: "didShowWelcome")
    }

    private func setupMockActions() {
        app.actions.characterList.loadCharacters = { [weak self] limit, offset in
            try? await Task.sleep(for: .seconds(1))
            let characters = self?.configuration.characters.dropFirst(offset).prefix(limit) ?? []
            var loadingState = LoadingState<Int, [Character]>(input: offset)
            loadingState.state = .completed(Array(characters))
            return loadingState
        }

        app.actions.characterList.loadMoreCharacters = { [weak self] currentCount in
            try? await Task.sleep(for: .seconds(1))
            let newCharacters = self?.configuration.characters.dropFirst(currentCount).prefix(20) ?? []
            var loadingState = LoadingState<Int, [Character]>(input: currentCount)
            loadingState.state = .completed(Array(newCharacters))
            return loadingState
        }

        app.actions.comicListForCharacter.loadComics = { [weak self] _, limit, offset in
            try? await Task.sleep(for: .seconds(1))
            let comics = self?.configuration.comics.dropFirst(offset).prefix(limit) ?? []
            var loadingState = LoadingState<Int, [Comic]>(input: offset)
            loadingState.state = .completed(Array(comics))
            return loadingState
        }

        app.actions.comicListForCharacter.loadMoreComics = { [weak self] _, currentCount in
            try? await Task.sleep(for: .seconds(1))
            let newComics = self?.configuration.comics.dropFirst(currentCount).prefix(20) ?? []
            var loadingState = LoadingState<Int, [Comic]>(input: currentCount)
            loadingState.state = .completed(Array(newComics))
            return loadingState
        }

        app.actions.characterFollowing.toggleFollowing = { character in
            try? await Task.sleep(for: .seconds(0.5))
            return !character.isFollowing
        }
        
        app.actions.characterFollowing.isFollowing = { _ in false }
    }

    public func inject(content: Content) -> some View {
        content
            .dependency(app)
            .defaultAppStorage(defaults)
    }

    public func makeCharacterListScreenFactory() -> some CharacterListScreenFactory {
        MockCharacterListScreenFactory()
    }

    public func makeCharacterDetailScreenFactory() -> some CharacterDetailScreenFactory {
        MockCharacterDetailScreenFactory()
    }
}
