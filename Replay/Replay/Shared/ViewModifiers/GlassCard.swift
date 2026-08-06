//
//  GlassCard.swift
//  Replay
//
//  Created by Anandhakrishnan on 03/08/26.
//

// Core/Theme/View+GlassCard.swift

import SwiftUI

extension View {
    func replayGlassCard(cornerRadius: CGFloat = 20) -> some View {
        self
            .background(
                ZStack {
                    Color.replayDetailBackgroundTop.opacity(0.35)
                    Rectangle().fill(.ultraThinMaterial.opacity(0.1))
                }
                .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
            )
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .stroke(.white.opacity(0.06), lineWidth: 1)
            )
    }
}
