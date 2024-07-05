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
        ZStack(alignment: .bottom) {
            ImageView(
                url: character.thumbnail?.fullPath,
                size: CGSize(width: 800, height: 400)
            )
                .aspectRatio(contentMode: .fill)
                .frame(height: 400)
                .clipped()

            LinearGradient(gradient: Gradient(colors: [.clear, .black.opacity(0.8)]),
                           startPoint: .top,
                           endPoint: .bottom)
            .frame(height: 200)

            HStack(alignment: .bottom) {
                VStack(alignment: .leading) {
                    Text(character.name)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.white)

                    Button(action: {
                        Task {
                            do {
                                character.isFollowing = try await actions.characterFollowing.toggleFollowing(character)
                            } catch {
                                errorAlertState.alert = .init(message: "Failed to update following status")
                            }
                        }
                    }) {
                        HStack {
                            Image(systemName: character.isFollowing ? "checkmark" : "plus")
                            Text(character.isFollowing ? "Following" : "Follow")
                        }
                        .padding(.horizontal, 20)
                        .padding(.vertical, 10)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(20)
                    }
                }
                Spacer()
            }
            .padding()
        }
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
