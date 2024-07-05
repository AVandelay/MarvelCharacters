//
//  AppDependency.swift
//
//
//  Created by Ken Westdorp on 7/5/24.
//

import Core
import SwiftUI

public struct AppDependency: Dependency {
    public var state: AppState
    public var actions: AppActions

    public init(state: AppState, actions: AppActions) {
        self.state = state
        self.actions = actions
    }
}
