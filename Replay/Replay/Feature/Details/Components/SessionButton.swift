//
//  SessionButton.swift
//  Replay
//
//  Created by Anandhakrishnan on 27/07/26.
//

import SwiftUI

struct SessionButton: View {
    let action: () -> Void

    var body: some View {
        GlassEffectContainer {
                    Button(action: action) {
                        HStack(spacing: 8) {
                            Image(systemName: "gamecontroller.fill")
                            Text("Log Session")
                                .font(.body.weight(.semibold))
                        }
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                    }
                    .glassEffect(.clear, in: Capsule())
                }
                .padding(.horizontal, 20)
        
    }
}
