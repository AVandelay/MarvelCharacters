//
//  CharacterView.swift
//
//
//  Created by Ken Westdorp on 7/5/24.
//

import Core
import CommonUI
import SwiftUI

struct CharacterView: View {
    let character: Character

    var body: some View {
        VStack {
            ImageView(
                url: character.thumbnail?.fullPath,
                size: CGSize(width: 50, height: 50)
            )
            .clipShape(.circle)
            .overlay(Circle().stroke(Color.white, lineWidth: 4))
            .shadow(radius: 10)

            Text(character.name)
                .font(.headline)
                .multilineTextAlignment(.center)
                .lineLimit(2)
                .frame(width: 200)
        }
    }
}
