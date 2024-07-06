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
        VStack(alignment: .leading, spacing: 10) {
            ImageView(url: comic.thumbnail?.fullPath, size: CGSize(width: 200, height: 300))
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.white, lineWidth: 2))
                .shadow(radius: 5)

            Text(comic.title)
                .font(.headline)
                .multilineTextAlignment(.leading)

            if let formattedIssueNumber = comic.formattedIssueNumber {
                Text("Issue \(formattedIssueNumber)")
                    .font(.subheadline)
                    .multilineTextAlignment(.leading)
            }
        }
        .frame(width: 200)
    }
}
