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
    
    private(set) var searchState: SearchState = .idle
    var toastMessage: String?
    
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
            searchState = .idle
            return
        }
        
        searchTask = Task { [weak self] in
            guard let self else { return }
            
            try? await Task.sleep(for: self.debounceDelay)
            guard !Task.isCancelled else { return }
            
            self.searchState = .searching
            do {
                let results = try await self.searchClient.search(query: query)
                guard !Task.isCancelled else { return }
                self.searchState = results.isEmpty ? .empty : .results(results)
            } catch is CancellationError {
                // Superseded by a newer keystroke's search — ignore silently
            } catch {
                guard !Task.isCancelled else { return }
                self.searchState = .failed("An eror occurred. Try again.")
            }
        }
    }
    
    // MARK: - Add to library
    
    /// Maps a search result into the persisted domain model and saves it.
    /// Returns after the repository write completes so the row can show
    /// its confirmation state.
    func addGame(from result: GameSearchResult) async {
        do {
            // check if game already exists
            if try gameRepository.exists(igdbID: result.id) {
                toastMessage = "\(result.title) is already in your library."
                return
            }
            
            try gameRepository.create(title: result.title, coverURL: result.coverURL, releaseDate: result.releaseDate, igdbID: result.id, genre: result.genre)
            toastMessage = "Added \(result.title)."
        } catch {
            toastMessage = "Couldn't add \(result.title). Try again."
        }
    }
}


enum SearchState {
    case idle
    case searching
    case results([GameSearchResult])
    case empty
    case failed(String)
}
