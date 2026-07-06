//
//  QuickLogViewModel.swift
//  Replay
//
//  Created by Anandhakrishnan on 03/07/26.
//

import Foundation

@MainActor
@Observable
final class QuickLogViewModel {
    
    // MARK: - State
    
    var selectedGame: Game?
    var selectedMood: Mood?
    var note: String = ""
    var durationMinutes: Int = 30
    var isDurationEnabled: Bool = false
    var isLoading: Bool = false
    var errorMessage: String?
    
    // MARK: - Dependencies
    
    private let sessionRepository: SessionRepository
    private let gameRepository: GameRepository
    
    // MARK: - Init
    
    init(
        sessionRepository: SessionRepository,
        gameRepository: GameRepository,
        preselectedGame: Game? = nil
    ) {
        self.sessionRepository = sessionRepository
        self.gameRepository = gameRepository
        self.selectedGame = preselectedGame
    }
    
    // MARK: - Computed
    
    var canSubmit: Bool {
        selectedGame != nil && selectedMood != nil
    }
    
    var availableGames: [Game] {
        get throws {
            try gameRepository.fetchAll()
        }
    }
    
    // MARK: - Intent
    
    func logSession(onComplete: () -> Void) {
        guard let game = selectedGame,
              let mood = selectedMood else { return }
        
        isLoading = true
        defer { isLoading = false }
        
        do {
            try sessionRepository.create(
                gameID: game.id,
                mood: mood,
                note: note.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? nil : note,
                durationMinutes: isDurationEnabled ? durationMinutes : nil
            )
            errorMessage = nil
            onComplete()
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
    func selectGame(_ game: Game) {
        selectedGame = game
    }
    
    func selectMood(_ mood: Mood) {
        selectedMood = mood
    }
}
