//
//  ComicView.swift
//
//
//  Created by Ken Westdorp on 7/5/24.
//

import Core
import CommonUI
import SwiftUI

struct ComicView: View {
    let comic: Comic

    var body: some View {
        let subtitle = if comic.formattedIssueNumber != nil {
            comic.formattedIssueNumber
        } else {
           ""
        }

        FocusableItemView(
            imageURL: comic.thumbnail?.fullPath,
            imageShape: .rectangle,
            title: comic.title,
            subtitle: subtitle,
            action: { }
        )
    }
}
