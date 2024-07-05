//
//  AppActions.swift
//
//
//  Created by Ken Westdorp on 7/5/24.
//

import Core
import SwiftUI

@MainActor 
public struct AppActions: ViewInjectable {
    struct Key: EnvironmentKey {
        static let defaultValue = AppActions()
    }

    public var characterList = CharacterList()
    public var comicListForCharacter = ComicListForCharacter()

    nonisolated public init() { }

    public func inject(content: Content) -> some View {
        content
            .environment(\.appActions, self)
    }
}

extension EnvironmentValues {
    public var appActions: AppActions {
        get { self[AppActions.Key.self] }
        set { self[AppActions.Key.self] = newValue }
    }
}
