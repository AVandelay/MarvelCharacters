//
//  AppActions+ComicListForCharacter.swift
//
//
//  Created by Ken Westdorp on 7/5/24.
//

import Core
import Foundation

extension AppActions {
    @MainActor
    public struct ComicListForCharacter {
        public var loadComics: (_ characterID: CharacterID, _ limit: Int, _ offset: Int) async throws -> LoadingState<Int, [Comic]> = emptyAction(throwing: ErrorMessage(message: "Unimplemented"))
        public var loadMoreComics: (_ characterID: CharacterID, _ currentCount: Int) async throws -> LoadingState<Int, [Comic]> = emptyAction(throwing: ErrorMessage(message: "Unimplemented"))

        nonisolated init() { }
    }
}
