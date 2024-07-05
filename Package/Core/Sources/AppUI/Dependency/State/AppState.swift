//
//  AppState.swift
//
//
//  Created by Ken Westdorp on 7/5/24.
//

import Core
import SwiftUI

@MainActor 
public struct AppState: ViewInjectable {
    public var errorAlert = ErrorAlert()

    public init() { }

    public func inject(content: Content) -> some View {
        content
            .environmentObject(errorAlert)
    }
}
