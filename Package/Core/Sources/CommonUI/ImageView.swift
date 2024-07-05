//
//  ImageView.swift
//
//
//  Created by Ken Westdorp on 7/5/24.
//

import SwiftUI

public struct ImageView: View {
    let url: URL?
    let size: CGSize

    public init(url: URL?, size: CGSize) {
        self.url = url
        self.size = size
    }

    public var body: some View {
        AsyncImage(url: url) { phase in
            switch phase {
            case .empty:
                ProgressView()
                    .frame(width: size.width, height: size.height)
            case .success(let image):
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: size.width, height: size.height)
                    .clipped()
            case .failure:
                TaskFailedView()
                    .frame(width: size.width, height: size.height)
            @unknown default:
                ProgressView()
            }
        }
    }
}
