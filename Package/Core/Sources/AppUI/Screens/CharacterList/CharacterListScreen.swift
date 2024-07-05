//
//  CharacterListScreen.swift
//
//
//  Created by Ken Westdorp on 7/5/24.
//

import Core
import CommonUI
import SwiftUI

struct CharacterListScreen<Factory: CharacterListScreenFactory>: View {
    let factory: Factory
    let onCharacterSelected: (Character) -> Void
    @State private var loadingState: LoadingState<Int, [Character]> = LoadingState(input: 0)
    @State private var isLoadingMore = false
    @Environment(\.appActions) private var actions
    @EnvironmentObject private var errorAlertState: AppState.ErrorAlert

    var body: some View {
        WithProperty(factory.makeScreenData(loadingState: loadingState)) { screenData in
            HorizontalScrollView(
                items: screenData.characters,
                loadMore: loadMoreCharacters,
                isLoadingMore: isLoadingMore
            ) { character in
                CharacterView(character: screenData.character(character))
                    .onTapGesture {
                        onCharacterSelected(character)
                    }
            }
        }
        .task {
            await loadCharacters()
        }
        .dependency(factory)
    }

    private func loadCharacters() async {
        do {
            loadingState = try await actions.characterList.loadCharacters(20, 0)
        } catch {
            errorAlertState.alert = .init(message: "Failed to load characters")
        }
    }

    private func loadMoreCharacters() async {
        guard !isLoadingMore else { return }
        isLoadingMore = true

        do {
            let newState = try await actions.characterList.loadMoreCharacters(loadingState.value?.count ?? 0)
            if case .completed(let newCharacters) = newState.state {
                if var currentCharacters = loadingState.value {
                    currentCharacters.append(contentsOf: newCharacters)
                    loadingState.state = .completed(currentCharacters)
                } else {
                    loadingState = newState
                }
            }
        } catch {
            errorAlertState.alert = .init(message: "Failed to load more characters")
        }

        isLoadingMore = false
    }
}

// MARK: - CharacterListScreenFactory

@MainActor
public protocol CharacterListScreenFactory: ViewInjectable {
    associatedtype ScreenData: CharacterListScreenData
    func makeScreenData(loadingState: LoadingState<Int, [Character]>) -> ScreenData
}

@MainActor
public protocol CharacterListScreenData: DynamicProperty {
    var characters: [Character] { get }
    func character(_ character: Character) -> Character
}

// MARK: - Mocks

struct MockCharacterListScreenFactory: CharacterListScreenFactory {
    func makeScreenData(loadingState: LoadingState<Int, [Character]>) -> MockCharacterListScreenData {
        MockCharacterListScreenData(loadingState: loadingState)
    }

    func inject(content: Content) -> some View {
        content
    }
}

struct MockCharacterListScreenData: CharacterListScreenData {
    let loadingState: LoadingState<Int, [Character]>

    var characters: [Character] {
        loadingState.value ?? []
    }

    func character(_ character: Character) -> Character {
        character
    }
}

// MARK: - Components

enum CharacterListScreenDestination: Hashable {
    case comics(for: Character)
}
