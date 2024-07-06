//
//  File.swift
//
//
//  Created by Ken Westdorp on 7/5/24.
//

import Core
import Foundation

extension AppActions {
    @MainActor
    public struct CharacterFollowing {
        public var toggleFollowing: (Character) async throws -> Bool = emptyAction(throwing: ErrorMessage(message: "Unimplemented"))
        public var isFollowed: (CharacterID) -> Bool = emptyAction(returning: false)

        nonisolated init() { }
    }
}
