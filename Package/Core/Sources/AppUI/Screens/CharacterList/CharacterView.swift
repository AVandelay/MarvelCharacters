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
    let onSelect: (Character) -> Void

    var body: some View {
        FocusableItemView(
            imageURL: character.thumbnail?.fullPath,
            imageShape: .round,
            title: character.name,
            action: { onSelect(character) }
        )
    }
}
