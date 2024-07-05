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

    associatedtype CharacterDetailScreenFactory: AppUI.CharacterDetailScreenFactory
    func makeCharacterDetailScreenFactory() -> CharacterDetailScreenFactory
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
