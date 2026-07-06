//
//  GamePickerSheet.swift
//  Replay
//
//  Created by Anandhakrishnan on 03/07/26.
//

import SwiftUI

struct GamePickerSheet: View {
    
    let games: [Game]
    let onSelect: (Game) -> Void
    
    @Environment(\.dismiss) private var dismiss
    @State private var searchText = ""
    
    private var filteredGames: [Game] {
        guard !searchText.trimmingCharacters(in: .whitespaces).isEmpty else {
            return games
        }
        return games.filter {
            $0.title.localizedCaseInsensitiveContains(searchText)
        }
    }
    
    var body: some View {
        NavigationStack {
            List(filteredGames) { game in
                Button {
                    onSelect(game)
                    dismiss()
                } label: {
                    GameRow(game: game)
                }
                .buttonStyle(.plain)
            }
            .searchable(text: $searchText, prompt: "Search games")
            .navigationTitle("Pick a Game")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
            }
            .overlay {
                if filteredGames.isEmpty {
                    emptyState
                }
            }
        }
    }
    
    private var emptyState: some View {
        ContentUnavailableView(
            searchText.isEmpty ? "No Games" : "No Results",
            systemImage: "gamecontroller",
            description: Text(
                searchText.isEmpty
                ? "Add a game to your library first"
                : "No games matching \"\(searchText)\""
            )
        )
    }
}
