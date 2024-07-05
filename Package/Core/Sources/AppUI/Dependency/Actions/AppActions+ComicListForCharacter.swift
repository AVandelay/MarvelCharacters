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
        public var getComics: (CharacterID) async throws -> [Comic] = emptyAction(throwing: .message("Unimplemented"))
        nonisolated init() { }
    }
}
