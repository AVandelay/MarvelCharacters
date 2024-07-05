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
        public var refresh: () async throws -> Void = emptyAction()
        nonisolated init() { }
    }
}
