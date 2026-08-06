//
//  SessionNotesEditor.swift
//  Replay
//
//  Created by Anandhakrishnan on 27/07/26.
//

import SwiftUI

struct SessionNotesEditor: View {
    @Binding var text: String

    var body: some View {
        ZStack(alignment: .topLeading) {
            if text.isEmpty {
                Text("How did this session feel?")
                    .foregroundStyle(.white.opacity(0.35))
                    .padding(.horizontal, 12)
                    .padding(.vertical, 12)
            }

            TextEditor(text: $text)
                .scrollContentBackground(.hidden)
                .foregroundStyle(.white)
                .padding(.horizontal, 8)
                .padding(.vertical, 6)
        }
        .frame(height: 160)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white.opacity(0.05))
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color.white.opacity(0.1), lineWidth: 1)
                )
        )
    }
}
