//
//  MoodSelectorRow.swift
//  Replay
//
//  Created by Anandhakrishnan on 27/07/26.
//

import SwiftUI

struct MoodSelectorRow: View {
    @Binding var selectedMood: Mood
    @Namespace private var animation

    private let accent = Color.purple // placeholder until a theme token exists

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach(Mood.allCases) { mood in
                    pill(for: mood)
                }
            }
            .padding(.vertical, 4) // room for the stroke/shadow so it isn't clipped
        }
    }

    @ViewBuilder
    private func pill(for mood: Mood) -> some View {
        let isSelected = mood == selectedMood

        Button {
            withAnimation(.bouncy) {
                selectedMood = mood
            }
        } label: {
            HStack(spacing: 8) {
                Text(mood.emoji)
                Text(mood.label)
                    .font(.subheadline.bold())
            }
            .foregroundStyle(isSelected ? accent : .white)
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
            .background(background(isSelected: isSelected))
        }
        .buttonStyle(.plain)
    }

    @ViewBuilder
    private func background(isSelected: Bool) -> some View {
        if isSelected {
            Capsule()
                .fill(accent.opacity(0.18))
                .overlay(Capsule().stroke(accent, lineWidth: 1))
                .matchedGeometryEffect(id: "moodHighlight", in: animation)
        } else {
            Capsule()
                .fill(Color.white.opacity(0.05))
                .overlay(Capsule().stroke(Color.white.opacity(0.1), lineWidth: 1))
        }
    }
}
