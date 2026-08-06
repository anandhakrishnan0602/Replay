//
//  GameDetailBackground.swift
//  Replay
//
//  Created by Anandhakrishnan on 03/08/26.
//

import SwiftUI

struct GameDetailBackground: ViewModifier {
    func body(content: Content) -> some View {
        content.background(
            LinearGradient(
                colors: [.clear, .replayDetailBackgroundTop, .replayDetailBackgroundBottom],
                startPoint: .top,
                endPoint: .bottom
            )
//            .ignoresSafeArea()
        )
    }
}

extension View {
    func gameDetailBackground() -> some View {
        modifier(GameDetailBackground())
    }
}
