//
//  AppState+ErrorAlert.swift
//
//
//  Created by Ken Westdorp on 7/5/24.
//

import Core
import Foundation

extension AppState {
    @MainActor 
    public final class ErrorAlert: ObservableObject {
        @Published public var alert: DisplayableError?

        public init() { }
    }
}
