//
//  AppState+ErrorAlert.swift
//
//
//  Created by Ken Westdorp on 7/5/24.
//

import Core
import Foundation

@MainActor
public protocol ErrorAlertProtocol: AnyObject, ObservableObject {
    var alert: DisplayableError? { get set }
}

extension AppState {
    @MainActor
    public final class ErrorAlert: ErrorAlertProtocol {
        @Published public var alert: DisplayableError?

        public init() { }
    }
}
