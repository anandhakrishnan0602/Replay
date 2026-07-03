//
//  LibraryView.swift
//  Replay
//
//  Created by Anandhakrishnan on 30/06/26.
//

import SwiftUI
import CoreData

struct LibraryView: View {
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \GameEntity.dateAdded, ascending: false)]
    )
    private var games: FetchedResults<GameEntity>

    @State private var showingAddGame = false
    @State private var selectedGame: GameEntity?

    var body: some View {
        NavigationStack {
            Group {
                if games.isEmpty {
                    ContentUnavailableView(
                        "No Games Yet",
                        systemImage: "gamecontroller",
                        description: Text("Add a game to start your journal.")
                    )
                } else {
                    List {
                        ForEach(games) { game in
                            Button {
                                selectedGame = game
                            } label: {
                                GameRow(game: game)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }
            }
            .navigationTitle("Library")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        showingAddGame = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingAddGame) {
                AddEditGameView(game: nil)
            }
            .sheet(item: $selectedGame) { game in
                AddEditGameView(game: game.toDomain())
            }
        }
    }
}

private struct GameRow: View {
    let game: GameEntity

    var body: some View {
        HStack(spacing: 12) {
            AsyncImage(url: game.coverUrl) { image in
                image.resizable().aspectRatio(contentMode: .fill)
            } placeholder: {
                Rectangle().fill(.secondary.opacity(0.2))
            }
            .frame(width: 44, height: 44)
            .clipShape(RoundedRectangle(cornerRadius: 6))

            VStack(alignment: .leading, spacing: 2) {
                Text(game.title ?? "Untitled")
                    .font(.body)
                if let platform = game.platform, !platform.isEmpty {
                    Text(platform)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
        }
    }
}
