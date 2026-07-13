//
//  BackgroundGradient.swift
//  Replay
//
//  Created by Anandhakrishnan on 08/07/26.
//

import SwiftUI

struct BackgroundGradientModifier : ViewModifier {
    func body(content: Content) -> some View {
        ZStack {
            Group{
                // Base gradient — navy top to near-black bottom
                LinearGradient(
                    colors: [
                        Color("ReplayBackgroundTop"),
                        Color("ReplayBackgroundBottom")
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
                
                // Subtle radial purple glow — upper center
                RadialGradient(
                    colors: [
                        Color("ReplayAccentGlow").opacity(0.35),
                        Color.clear
                    ],
                    center: UnitPoint(x: 0.5, y: 0.25),
                    startRadius: 0,
                    endRadius: 300
                )
            }
            .ignoresSafeArea()
            content
        }
    }
}

extension View {
    func backgroundGradient() -> some View {
        modifier(BackgroundGradientModifier())
    }
}
