//
//  DetailsViewModel.swift
//  Replay
//
//  Created by Anandhakrishnan on 30/07/26.
//

import Foundation

@Observable
@MainActor
final class GameDetailViewModel {
    let game: Game
    private(set) var sessions: [Session] = []

    private let sessionRepository: SessionRepository

    init(game: Game, sessionRepository: SessionRepository? = nil ) {
        self.game = game
        self.sessionRepository = sessionRepository ?? SessionRepository(context: PersistenceController.shared.context)
    }

    func loadSessions() {
        do {
            sessions = try sessionRepository.fetchAll(for: game.id)
        } catch {
            print("error while fetching sessions: \(error)")
        }
    }
    
    func deleteSession(_ session: Session) {
        do{
            try sessionRepository.delete(id: session.id)
            sessions.removeAll { $0.id == session.id }
        } catch {
            print("error while deleting session: \(error)")
        }
    }

    // Computed stats, derived from real session data
    var sessionCount: Int {
        sessions.count
    }

    var averageMoodEmoji: String {
        guard !sessions.isEmpty else { return "—" }
        // placeholder logic — depends on how Mood is modeled (enum? raw score?)
        return sessions.first?.mood.emoji ?? "—"
    }

    var totalHoursPlayed: Int {
        let totalSeconds = sessions.reduce(into: 0) { $0 + ($1.durationMinutes ?? 0) }
        return Int(totalSeconds / 3600)
    }
}
