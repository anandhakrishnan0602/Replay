//
//  LibraryViewModel.swift
//  Replay
//
//  Created by Anandhakrishnan on 03/07/26.
//

import Foundation
import CoreData

@MainActor
@Observable
final class LibraryViewModel: NSObject {
    
    // MARK: - State
    
    private(set) var games: [Game] = []
    private(set) var isLoading = false
    var errorMessage: String?
    var searchText = ""
    private var fetchedResultsController: NSFetchedResultsController<GameEntity>?
    
    // MARK: - Dependencies
    
    private let repository: GameRepository
    
    // MARK: - Init
    
    init(repository: GameRepository? = nil) {
        self.repository = repository ?? GameRepository(context: PersistenceController.shared.context)
        super.init()
        setupFetchedResultsController()
    }
    
    private func setupFetchedResultsController() {
        let request = GameEntity.fetchRequest()
        request.sortDescriptors = [
            NSSortDescriptor(key: "lastPlayed", ascending: false)
        ]

        fetchedResultsController = NSFetchedResultsController(
            fetchRequest: request,
            managedObjectContext: PersistenceController.shared.context,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
        fetchedResultsController?.delegate = self

        do {
            try fetchedResultsController?.performFetch()
            errorMessage = nil
            updateGames()
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
    private func updateGames() {
        let fetched = (fetchedResultsController?.fetchedObjects ?? []).map { $0.toDomain() }
        let played = fetched.filter { $0.lastPlayed != nil }
        let unplayed = fetched.filter { $0.lastPlayed == nil }
        games = played + unplayed
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

extension LibraryViewModel: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        updateGames()
    }
}
