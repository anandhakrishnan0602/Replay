//
//  SessionListView.swift
//  Replay
//
//  Created by Anandhakrishnan on 25/07/26.
//

// Features/GameDetail/SessionsListView.swift

import SwiftUI

struct SessionsListView: View {
    let sessions: [Session]
    let onSessionTap: (Session) -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Sessions (\(sessions.count))")
                    .font(.title3.weight(.bold))
                    .foregroundStyle(.white)

                Spacer()

                Button {
                    // filter action — hook up later
                } label: {
                    Image(systemName: "line.3.horizontal.decrease")
                        .foregroundStyle(.white.opacity(0.7))
                }
            }

            VStack(spacing: 12) {
                ForEach(sessions, id: \.id) { session in
                    SessionRowView(
                        dateMonth: session.date.monthAbbreviation,
                        dateDay: session.date.dayNumber,
                        moodEmoji: session.mood.emoji,
                        note: session.note ?? "",
                        duration: session.durationMinutes?.formattedDuration ?? "—"
                    )
                    .onTapGesture {
                        onSessionTap(session)
                    }
                    
                }
            }
        }
        .padding(.horizontal, 20)
    }
}

struct SessionRowView: View {
    let dateMonth: String   // e.g. "JUL"
    let dateDay: String     // e.g. "14"
    let moodEmoji: String
    let note: String
    let duration: String    // e.g. "2h 15m"

    var body: some View {
        HStack(spacing: 16) {
            VStack(spacing: 2) {
                Text(dateMonth.uppercased())
                    .font(.caption2.weight(.semibold))
                    .foregroundStyle(.white.opacity(0.5))
                Text(dateDay)
                    .font(.title3.weight(.bold))
                    .foregroundStyle(.white)
            }
            .frame(width: 44)
            
            ZStack {
                Circle()
                    .fill(.white.opacity(0.08))
                    .frame(width: 40, height: 40)
                Text(moodEmoji)
                    .font(.title3)
            }
            
            Text(note)
                .font(.subheadline)
                .foregroundStyle(.white.opacity(0.9))
                .lineLimit(1)
                .truncationMode(.tail)
            
            Spacer(minLength: 8)
            
            Text(duration)
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(Color.accentColor)
        }
        .padding(16)
        .replayGlassCard()
    }
}
