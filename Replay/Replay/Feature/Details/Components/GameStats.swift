//
//  GameStats.swift
//  Replay
//
//  Created by Anandhakrishnan on 25/07/26.
//

import SwiftUI
struct GameStats: View {
    let sessionCount: Int
        let averageMoodEmoji: String
        let hoursPlayed: Int

        var body: some View {
            HStack(spacing: 0) {
                statColumn(label: "SESSIONS", value: "\(sessionCount)")

                divider

                statColumn(label: "AVG MOOD", value: averageMoodEmoji)

                divider

                statColumn(label: "PLAYED", value: "\(hoursPlayed)h")
            }
            .padding(.vertical, 20)
            .frame(maxWidth: .infinity)
            .replayGlassCard()
            .padding(.horizontal, 20)
        }

        private func statColumn(label: String, value: String) -> some View {
            VStack(spacing: 8) {
                Text(label)
                    .font(.caption2.weight(.semibold))
                    .foregroundStyle(.white.opacity(0.6))
                Text(value)
                    .font(.title2.weight(.bold))
                    .foregroundStyle(.white)
            }
            .frame(maxWidth: .infinity)
        }

        private var divider: some View {
            Rectangle()
                .fill(.white.opacity(0.12))
                .frame(width: 1, height: 32)
        }
}
