//
//  RelativeSizeLayout.swift
//
//
//  Created by Ken Westdorp on 7/6/24.
//

import SwiftUI

/// A custom layout that proposes a percentage of its
/// received proposed size to its subview.
///
/// - Precondition: must contain exactly one subview.
struct RelativeSizeLayout: Layout {
    var relativeWidth: Double
    var relativeHeight: Double

    func sizeThatFits(
        proposal: ProposedViewSize,
        subviews: Subviews,
        cache: inout ()
    ) -> CGSize {
        assert(subviews.count == 1, "expects a single subview")
        let resizedProposal = ProposedViewSize(
            width: proposal.width.map { $0 * relativeWidth },
            height: proposal.height.map { $0 * relativeHeight }
        )
        return subviews[0].sizeThatFits(resizedProposal)
    }

    func placeSubviews(
        in bounds: CGRect,
        proposal: ProposedViewSize,
        subviews: Subviews,
        cache: inout ()
    ) {
        assert(subviews.count == 1, "expects a single subview")
        let resizedProposal = ProposedViewSize(
            width: proposal.width.map { $0 * relativeWidth },
            height: proposal.height.map { $0 * relativeHeight }
        )
        subviews[0].place(
            at: CGPoint(x: bounds.midX, y: bounds.midY),
            anchor: .center,
            proposal: resizedProposal
        )
    }
}

public extension View {
    /// Proposes a percentage of its received proposed size to `self`.
    func relativeProposed(width: Double = 1, height: Double = 1) -> some View {
        RelativeSizeLayout(relativeWidth: width, relativeHeight: height) {
            VStack {
                self
            }
        }
    }
}
