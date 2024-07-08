//
//  FollowButton.swift
//
//
//  Created by Ken Westdorp on 7/6/24.
//

import SwiftUI
import Combine

struct FollowButton: View {
    struct Sparkle: View {
        let isFollowed: Bool

        var body: some View {
            Image(systemName: isFollowed ? "star" : "star.fill")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: CGFloat.random(in: 5...15), height: CGFloat.random(in: 5...15))
                .rotationEffect(.degrees(Double.random(in: 0...360)))
                .foregroundColor(.white.opacity(.random(in: 0.5...1)))
        }
    }

    @State private var animateSparkles = false
    @State private var cancellable: AnyCancellable?

    @FocusState private var isFocused: Bool

    @Binding var isFollowed: Bool

    var toggleFollowState: () async throws -> Bool

    var body: some View {
        HStack {
            ZStack {
                Image(systemName: isFollowed ? "star.fill" : "star")
                    .resizable()
                    .frame(width: 50, height: 50)
                    .foregroundColor(.white)

                if animateSparkles {
                    ForEach(0..<10) { i in
                        Sparkle(isFollowed: isFollowed)
                            .offset(x: CGFloat.random(in: -25...25), y: CGFloat.random(in: -25...25))
                            .opacity(animateSparkles ? 1 : 0)
                            .animation(
                                .easeInOut(duration: 0.3).repeatForever(autoreverses: true).delay(Double(i) * 0.1),
                                value: animateSparkles
                            )
                    }
                }
            }

            Text(isFollowed ? "FOLLOWED" : "FOLLOW CHARACTER")
                .foregroundColor(.white)
                .font(.headline)
                .padding(.leading, 10)
        }
        .padding()
        .background(isFocused ? Color.gray : Color.clear)
        .cornerRadius(10)
        .focusable(true)
        .focused($isFocused)
        .onTapGesture {
            Task {
                await toggleFollow()
            }
        }
    }

    private func startAnimation() {
        animateSparkles = true
        cancellable = Timer.publish(every: 0.1, on: .main, in: .common)
            .autoconnect()
            .sink { _ in
                withAnimation {
                    animateSparkles.toggle()
                }
            }

        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            cancellable?.cancel()
            animateSparkles = false
        }
    }

    private func toggleFollow() async {
        let wasFollowed = isFollowed
        isFollowed.toggle()
        startAnimation()

        do {
            let result = try await toggleFollowState()
            if result != isFollowed {
                isFollowed = result
            }
        } catch {
            isFollowed = wasFollowed
        }
    }
}
