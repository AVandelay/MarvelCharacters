//
//  HorizontalScrollView.swift
//
//
//  Created by Ken Westdorp on 7/5/24.
//

import SwiftUI

public struct HorizontalScrollView<Item: Identifiable, ItemView: View>: View {
    let items: [Item]
    let loadMore: () async -> Void
    let isLoadingMore: Bool
    let itemView: (Item) -> ItemView

    public init(
        items: [Item],
        loadMore: @escaping () async -> Void,
        isLoadingMore: Bool,
        itemView: @escaping (Item) -> ItemView
    ) {
        self.items = items
        self.loadMore = loadMore
        self.isLoadingMore = isLoadingMore
        self.itemView = itemView
    }

    public var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack(spacing: 40) {
                ForEach(items) { item in
                    itemView(item)
                }

                if !items.isEmpty {
                    lastItemView
                }
            }
            .padding(.horizontal)
        }
    }

    @ViewBuilder
    private var lastItemView: some View {
        if isLoadingMore {
            ProgressView()
        } else {
            EmptyView()
                .onAppear {
                    Task {
                        await loadMore()
                    }
                }
        }
    }
}
