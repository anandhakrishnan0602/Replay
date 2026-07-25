//
//  AddGameViewModel.swift
//  Replay
//
//  Created by Anandhakrishnan on 17/07/26.
//


import Foundation
import Observation

@MainActor
@Observable
final class AddGameSearchViewModel {
    
    // MARK: - State
    
    var searchText: String = "" {
        didSet {
            guard searchText != oldValue else { return }
            scheduleSearch()
        }
    }
    
    private(set) var searchResults: [GameSearchResult] = []
    private(set) var isSearching: Bool = false
    private(set) var errorMessage: String?
    
    // MARK: - Dependencies
    
    private let searchClient: GameSearching
    private let gameRepository: GameRepository
    
    private var searchTask: Task<Void, Never>?
    private let debounceDelay: Duration = .milliseconds(400)
    
    // MARK: - Init
    
    init(
        gameRepository: GameRepository? = nil,
        searchClient: GameSearching? = nil
    ) {
        if let searchClient {
            self.searchClient = searchClient
        } else {
            let authProvider = TwitchAuthProvider(
                clientID: AppSecrets.igdbClientID,
                clientSecret: AppSecrets.igdbClientSecret
            )
            self.searchClient = IGDBSearchClient(
                authProvider: authProvider,
                clientID: AppSecrets.igdbClientID)
        }
        self.gameRepository = gameRepository ?? GameRepository(context: PersistenceController.shared.context)
    }
    
    // MARK: - Search
    
    private func scheduleSearch() {
        searchTask?.cancel()
        
        let query = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard !query.isEmpty else {
            searchResults = []
            errorMessage = nil
            isSearching = false
            return
        }
        
        searchTask = Task { [weak self] in
            guard let self else { return }
            
            try? await Task.sleep(for: self.debounceDelay)
            guard !Task.isCancelled else { return }
            
            print("Searching")
            self.isSearching = true
            self.errorMessage = nil
            
            do {
                let results = try await self.searchClient.search(query: query)
                guard !Task.isCancelled else { return }
                self.searchResults = results
            } catch is CancellationError {
                // Superseded by a newer keystroke's search — ignore silently
            } catch {
                guard !Task.isCancelled else { return }
                self.searchResults = []
                self.errorMessage = "Couldn't load results. Check your connection and try again."
            }
            
            self.isSearching = false
        }
    }
    
    // MARK: - Add to library
    
    /// Maps a search result into the persisted domain model and saves it.
    /// Returns after the repository write completes so the row can show
    /// its confirmation state.
        func addGame(from result: GameSearchResult) async {
//            let game = Game(
//                id: UUID(),
//                title: result.title,
//                coverURL: result.coverURL,
//                releaseDate: result.releaseDate,
//                dateAdded: Date(),
//                sessions: []
////                genre: result.genre,
//            )
    
            do {
                try gameRepository.create(title: result.title, coverURL: result.coverURL, releaseDate: result.releaseDate, igdbID: result.id, genre: result.genre)
            } catch {
                errorMessage = "Couldn't add \(result.title). Try again."
            }
        }
}
