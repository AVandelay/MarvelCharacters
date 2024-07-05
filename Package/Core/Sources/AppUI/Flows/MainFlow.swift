//
//  MainFlow.swift
//
//
//  Created by Ken Westdorp on 7/5/24.
//

import SwiftUI

struct MainFlow<Container: AppContainer>: View {
    let container: Container

    var body: some View {
        Content(flow: self)
            .dependency(container)
    }
}

extension MainFlow {
    private struct Content: View {
        let flow: MainFlow

        var body: some View {
            CharacterListFlow(container: flow.container)
                .dependency(flow.container)
        }
    }
}
