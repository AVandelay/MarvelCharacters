//
//  UserDefaults+Helpers.swift
//
//
//  Created by Ken Westdorp on 7/5/24.
//

import Foundation

extension UserDefaults {
    public static func mock(name: String = UUID().uuidString) -> UserDefaults {
        let defaults = UserDefaults(suiteName: name)!
        defaults.removePersistentDomain(forName: name)
        return defaults
    }
}
