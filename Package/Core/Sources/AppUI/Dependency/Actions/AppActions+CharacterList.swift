//
//  AppActions+CharacterList.swift
//
//
//  Created by Ken Westdorp on 7/5/24.
//

import Core
import Foundation

extension AppActions {
    @MainActor
    public struct CharacterList {
        public var loadCharacters: (_ limit: Int, _ offset: Int) async throws -> LoadingState<Int, [Character]> = emptyAction(throwing: ErrorMessage(message: "Unimplemented"))
        public var loadMoreCharacters: (_ currentCount: Int) async throws -> LoadingState<Int, [Character]> = emptyAction(throwing: ErrorMessage(message: "Unimplemented"))

        nonisolated init() { }
    }
}
