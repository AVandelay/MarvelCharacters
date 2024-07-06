//
//  HorizontalScrollView.swift
//
//
//  Created by Ken Westdorp on 7/5/24.
//

import SwiftUI

struct HorizontalScrollView<Item: Identifiable, ItemView: View>: View {
    let items: [Item]
    let loadMore: () async -> Void
    let isLoadingMore: Bool
    let itemView: (Item) -> ItemView

    init(
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

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack(spacing: 60) {
                ForEach(items) { item in
                    itemView(item)
                }

                if !items.isEmpty {
                    lastItemView
                }
            }
            .padding(.horizontal, 90)
            .padding(.vertical, 60)
        }
    }

    @ViewBuilder
    private var lastItemView: some View {
        if isLoadingMore {
            ProgressView()
                .frame(width: 300, height: 400)
        } else {
            Color.clear
                .onAppear {
                    Task {
                        await loadMore()
                    }
                }
        }
    }
}
