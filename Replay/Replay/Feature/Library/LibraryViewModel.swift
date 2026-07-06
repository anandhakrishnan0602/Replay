//
//  LibraryViewModel.swift
//  Replay
//
//  Created by Anandhakrishnan on 03/07/26.
//

import Foundation

@MainActor
@Observable
final class LibraryViewModel {
    
    // MARK: - State
    
    private(set) var games: [Game] = []
    private(set) var isLoading = false
    var errorMessage: String?
    var searchText = ""
    
    // MARK: - Dependencies
    
    private let repository: GameRepository
    
    // MARK: - Init
    
    init(repository: GameRepository? = nil) {
        self.repository = repository ?? GameRepository(context: PersistenceController.shared.context)
    }
    
    // MARK: - Computed
    
    var filteredGames: [Game] {
        guard !searchText.trimmingCharacters(in: .whitespaces).isEmpty else {
            return games
        }
        return games.filter {
            $0.title.localizedCaseInsensitiveContains(searchText)
        }
    }
    
    var isEmpty: Bool {
        filteredGames.isEmpty
    }
    
    // MARK: - Intent
    
    func loadGames() {
        isLoading = true
        defer { isLoading = false }
        do {
            games = try repository.fetchAll()
            errorMessage = nil
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
    func deleteGame(id: UUID) {
        do {
            try repository.delete(id: id)
            games.removeAll { $0.id == id }
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
