//
//  FocusableItemView.swift
//
//
//  Created by Ken Westdorp on 7/5/24.
//

import CommonUI
import SwiftUI

struct FocusableItemView: View {
    enum ImageShape {
        case round
        case rectangle
    }

    let imageURL: URL?
    let title: String
    let subtitle: String?
    let imageShape: ImageShape
    let action: () -> Void

    @FocusState private var isFocused: Bool

    init(
        imageURL: URL?,
        imageShape: ImageShape,
        title: String,
        subtitle: String? = nil,
        action: @escaping () -> Void
    ) {
        self.imageURL = imageURL
        self.imageShape = imageShape
        self.title = title
        self.subtitle = subtitle
        self.action = action
    }

    var body: some View {
        Button(action: action) {
                VStack(spacing: 10) {
                    ImageView(
                        url: imageURL,
                        size: CGSize(width: 200, height: 200)
                    )
                        .clipShape(imageClipShape)
                        .scaleEffect(isFocused ? 1.1 : 1.0)
                        .shadow(radius: isFocused ? 10 : 0)

                    VStack(spacing: 5) {
                        Text(title)
                            .font(.headline)
                            .lineLimit(2)
                            .fixedSize(horizontal: false, vertical: true)
                            .multilineTextAlignment(.center)

                        if let subtitle = subtitle {
                            Text(subtitle)
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                                .multilineTextAlignment(.leading)
                        }
                    }
                    .offset(y: isFocused ? 10 : 0)
                }
                .padding()
                .cornerRadius(15)
                .shadow(
                    color: Color.black.opacity(0.2),
                    radius: isFocused ? 20 : 5,
                    x: 0,
                    y: isFocused ? 10 : 5
                )
//            }
        }
        .buttonStyle(PlainButtonStyle())
        .frame(width: 250, height: 350)
        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isFocused)
        .focused($isFocused)
    }

    private var imageClipShape: some Shape {
        switch imageShape {
        case .round:
            return AnyShape(Circle())
        case .rectangle:
            return AnyShape(RoundedRectangle(cornerRadius: 10))
        }
    }
}
