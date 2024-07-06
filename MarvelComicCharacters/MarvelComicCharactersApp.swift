//
//  MarvelComicCharactersApp.swift
//  MarvelComicCharacters
//
//  Created by Ken Westdorp on 7/4/24.
//

import Core
import LiveApp
import SwiftUI

@main
@MainActor
struct MarvelComicCharactersApp: App {
    static var configuration: LiveAppContainer.Configuration {
        .init(apiBaseURL: Configuration.baseURL, publicKey: Configuration.publicKey, privateKey: Configuration.privateKey)
    }

    @State var container = LiveAppContainer(configuration: configuration)

    var body: some Scene {
        WindowGroup {
            container.app
        }
    }
}
