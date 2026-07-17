//
//  SearchBar.swift
//  Replay
//
//  Created by Anandhakrishnan on 17/07/26.
//

import SwiftUI

struct SearchBar: View {
    @Binding var text: String
    var placeholder: String = "Search games..."
    @FocusState private var isFocused: Bool
    @Namespace private var glassNamespace
    
    var body: some View {
        GlassEffectContainer(spacing: 8) {
            HStack(spacing: 8) {
                // Search field — always present
                HStack(spacing: 10) {
                    Image(systemName: "magnifyingglass")
                        .foregroundStyle(.white.opacity(0.5))
                        .font(.system(size: 16, weight: .medium))
                    
                    TextField("", text: $text, prompt: Text(placeholder)
                        .foregroundStyle(.white.opacity(0.4)))
                    .foregroundStyle(.white)
                    .focused($isFocused)
                    .autocorrectionDisabled()
                    .textInputAutocapitalization(.never)
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .glassEffect(.regular, in: .capsule)
                .glassEffectID("searchField", in: glassNamespace)
                
                // Clear button — its own glass element, conditional
                if !text.isEmpty {
                    Button {
                        withAnimation(.easeInOut(duration: 0.2)) {
                            text = ""
                        }
                    } label: {
                        Image(systemName: "xmark")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundStyle(.white.opacity(0.6))
                            .padding(16)
                    }
                    .glassEffect(.regular, in: .circle)
                    .glassEffectID("clearButton", in: glassNamespace)
                    .transition(.opacity)
                }
            }
        }
        .animation(.bouncy(duration: 0.2), value: text.isEmpty)
    }
}
