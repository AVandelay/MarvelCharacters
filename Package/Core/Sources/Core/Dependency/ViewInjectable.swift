//
//  ViewInjectable.swift
//
//
//  Created by Ken Westdorp on 7/5/24.
//

import SwiftUI

public protocol ViewInjectable {
    typealias Content = ViewDependencyModifier<Self>.Content

    associatedtype InjectedBody: View

    @MainActor func inject(content: Content) -> InjectedBody
}

public struct ViewDependencyModifier<D: ViewInjectable>: ViewModifier {
    let dependency: D

    public func body(content: Content) -> some View {
        dependency.inject(content: content)
    }
}

extension View {
    public func dependency(_ dependency: some ViewInjectable) -> some View {
        modifier(ViewDependencyModifier(dependency: dependency))
    }
}
