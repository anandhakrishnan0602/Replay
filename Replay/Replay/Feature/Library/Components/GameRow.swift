//
//  GameRow.swift
//  Replay
//
//  Created by Anandhakrishnan on 03/07/26.
//

import SwiftUI

struct GameRow: View {
    let game: Game
    
    var body: some View {
        HStack(spacing: 12) {
            coverImage
            
            VStack(alignment: .leading, spacing: 4) {
                Text(game.title)
                    .font(.headline)
                    .lineLimit(1)
                
                if let platform = game.platform {
                    Text(platform)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .lineLimit(1)
                }
                
                if !game.sessions.isEmpty {
                    Text(lastSessionText)
                        .font(.caption)
                        .foregroundStyle(.tertiary)
                }
            }
            
            Spacer()
            
            moodIndicator
        }
        .padding(.vertical, 4)
    }
    
    // MARK: - Subviews
    
    @ViewBuilder
    private var coverImage: some View {
        if let url = game.coverURL {
            AsyncImage(url: url) { phase in
                switch phase {
                case .success(let image):
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                case .failure:
                    placeholderCover
                case .empty:
                    ProgressView()
                        .frame(width: 48, height: 64)
                @unknown default:
                    placeholderCover
                }
            }
            .frame(width: 48, height: 64)
            .clipShape(RoundedRectangle(cornerRadius: 8))
        } else {
            placeholderCover
        }
    }
    
    private var placeholderCover: some View {
        RoundedRectangle(cornerRadius: 8)
            .fill(.quaternary)
            .frame(width: 48, height: 64)
            .overlay {
                Image(systemName: "gamecontroller")
                    .foregroundStyle(.tertiary)
            }
    }
    
    @ViewBuilder
    private var moodIndicator: some View {
        if let lastSession = game.sessions.first {
            Text(lastSession.mood.emoji)
                .font(.title3)
        }
    }
    
    // MARK: - Helpers
    
    private var lastSessionText: String {
        guard let lastSession = game.sessions.first else { return "" }
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .abbreviated
        return "Last played \(formatter.localizedString(for: lastSession.date, relativeTo: .now))"
    }
}
