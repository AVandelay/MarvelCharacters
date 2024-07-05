//
//  AppContainer.swift
//
//
//  Created by Ken Westdorp on 7/5/24.
//

import Core
import SwiftUI

@MainActor 
public protocol AppContainer: DependencyContainer {
    var app: AppDependency { get }

    associatedtype CharacterListScreenFactory: AppUI.CharacterListScreenFactory
    func makeCharacterListScreenFactory() -> CharacterListScreenFactory

    associatedtype ComicListScreenFactory: AppUI.ComicListScreenFactory
    func makeComicListScreenFactory() -> ComicListScreenFactory
}

extension AppContainer {
    public func inject(content: Content) -> some View {
        content
            .dependency(app)
    }

    public var app: some View {
        MainFlow(container: self)
    }
}
