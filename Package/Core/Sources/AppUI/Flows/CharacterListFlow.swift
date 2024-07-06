//
//  CharacterListFlow.swift
//
//
//  Created by Ken Westdorp on 7/5/24.
//

import Core
import SwiftUI

struct CharacterListFlow<Container: AppContainer>: View {
    let container: Container

    var body: some View {
        Content(flow: self)
            .dependency(container)
    }
}

extension CharacterListFlow {
    private struct Content: View {
        let flow: CharacterListFlow
        @State private var navigationPath = NavigationPath()

        var body: some View {
            NavigationStack(path: $navigationPath) {
                CharacterListScreen(
                    factory: flow.container.makeCharacterListScreenFactory(),
                    onCharacterSelected: { character in
                        navigationPath.append(character)
                    }
                )
                .navigationTitle("Popular Characters".uppercased())
                .toolbar {
                    ToolbarItem(placement: .automatic) {
                        Button("SEE ALL") {
                            print("SEE ALL SELECTED")
                        }
                    }
                }
                .navigationDestination(for: Character.self) { character in
                    CharacterDetailScreen(
                        factory: flow.container.makeCharacterDetailScreenFactory(),
                        character: character
                    )
                }
            }
        }
    }
}
