//
//  File.swift
//
//
//  Created by Ken Westdorp on 7/5/24.
//

import SwiftUI

@MainActor public protocol Dependency: ViewInjectable {
    associatedtype State: ViewInjectable

    associatedtype Actions: ViewInjectable

    var state: State { get }

    var actions: Actions { get }
}

extension Dependency {
    public func inject(content: Content) -> some View {
        content
            .dependency(state)
            .dependency(actions)
    }
}
