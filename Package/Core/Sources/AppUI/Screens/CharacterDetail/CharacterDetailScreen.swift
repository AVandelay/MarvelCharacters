//
//  CharacterDetailScreen.swift
//
//
//  Created by Ken Westdorp on 7/5/24.
//

import Core
import CommonUI
import SwiftUI

struct CharacterDetailScreen<Factory: CharacterDetailScreenFactory>: View {
    let factory: Factory

    @State var character: Character
    @State private var loadingState: LoadingState<Int, [Comic]> = LoadingState(input: 0)
    @State private var isLoadingMore = false

    @FocusState private var isFocused: Bool

    @Environment(\.appActions) private var actions
    @EnvironmentObject private var errorAlertState: AppState.ErrorAlert

    var body: some View {
        VStack(spacing: 0) {
            characterHeader
            comicList
        }
        .task {
            character.isFollowing = actions.characterFollowing.isFollowing(character.id)
            await loadComics()
        }
        .dependency(factory)
    }

    private var characterHeader: some View {
        ZStack(alignment: .bottomLeading) {
            ImageView(
                url: character.thumbnail?.fullPath,
                size: CGSize(width: 1920, height: 400)
            )
            .frame(height: 400)
            .clipped()

            LinearGradient(
                gradient: Gradient(colors: [.black.opacity(0.7), .clear]),
                startPoint: .leading,
                endPoint: .trailing
            )
            .frame(height: 400)
            .relativeProposed(width: 1)

            VStack(alignment: .leading, spacing: 10) {
                Text(character.name)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .shadow(radius: 5)

                FollowButton()
                    .focused($isFocused)
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 20)
            .relativeProposed(width: 0.6)
        }
        .frame(height: 400)
    }

    private var comicList: some View {
        WithProperty(factory.makeScreenData(loadingState: loadingState)) { screenData in
            HorizontalScrollView(
                items: screenData.comics,
                loadMore: loadMoreComics,
                isLoadingMore: isLoadingMore
            ) { comic in
                ComicView(comic: screenData.comic(comic))
            }
        }
    }

    private func loadComics() async {
        do {
            loadingState = try await actions.comicListForCharacter.loadComics(character.id, 20, 0)
        } catch {
            errorAlertState.alert = .init(message: "Failed to load comics")
        }
    }

    private func loadMoreComics() async {
        guard !isLoadingMore else { return }
        isLoadingMore = true

        do {
            let newState = try await actions.comicListForCharacter.loadMoreComics(character.id, loadingState.value?.count ?? 0)
            if case .completed(let newComics) = newState.state {
                if var currentComics = loadingState.value {
                    currentComics.append(contentsOf: newComics)
                    loadingState.state = .completed(currentComics)
                } else {
                    loadingState = newState
                }
            }
        } catch {
            errorAlertState.alert = .init(message: "Failed to load more comics")
        }

        isLoadingMore = false
    }
}

// MARK: - CharacterDetailScreenFactory

@MainActor
public protocol CharacterDetailScreenFactory: ViewInjectable {
    associatedtype ScreenData: CharacterDetailScreenData
    func makeScreenData(loadingState: LoadingState<Int, [Comic]>) -> ScreenData
}

@MainActor
public protocol CharacterDetailScreenData: DynamicProperty {
    var comics: [Comic] { get }
    func comic(_ comic: Comic) -> Comic
}

// MARK: - MockCharacterDetailScreenData

struct MockCharacterDetailScreenFactory: CharacterDetailScreenFactory {
    func makeScreenData(loadingState: LoadingState<Int, [Comic]>) -> MockCharacterDetailScreenData {
        MockCharacterDetailScreenData(loadingState: loadingState)
    }

    func inject(content: Content) -> some View {
        content
    }
}

struct MockCharacterDetailScreenData: CharacterDetailScreenData {
    let loadingState: LoadingState<Int, [Comic]>

    var comics: [Comic] {
        loadingState.value ?? []
    }

    func comic(_ comic: Comic) -> Comic {
        comic
    }
}
