//
//  SessionLogViewModel.swift
//  Replay
//
//  Created by Anandhakrishnan on 28/07/26.
//

// Features/QuickLog/SessionLogViewModel.swift

import Foundation

@Observable
@MainActor
final class SessionLogViewModel {

    enum SaveState: Equatable {
        case idle
        case saving
        case saved
        case error(String)
    }

    // Form state
    var mood: Mood = .neutral
    var note: String = ""
    var date: Date = .now
    var durationMinutes: Int = 30

    private(set) var saveState: SaveState = .idle

    private let gameID: UUID
    private let existingSession: Session?
    private let repository: SessionRepository

    var isEditing: Bool { existingSession != nil }
    
    init(gameID: UUID, session: Session? = nil, repository: SessionRepository? = nil) {
        self.gameID = gameID
        self.existingSession = session
        self.repository = repository ?? SessionRepository(context: PersistenceController.shared.context)
        
        if let session {
            mood = session.mood
            note = session.note ?? ""
            date = session.date
            durationMinutes = session.durationMinutes ?? 30
        }
    }

    func save() {
        saveState = .saving

        let trimmedNote = note.trimmingCharacters(in: .whitespacesAndNewlines)
        let noteToSave = trimmedNote.isEmpty ? nil : trimmedNote


        do {
            if let existingSession {
                          let updated = Session(
                              id: existingSession.id,
                              date: date,
                              mood: mood,
                              note: noteToSave,
                              durationMinutes: durationMinutes
                          )
                          try repository.update(updated)
            } else {
                try repository.create(
                    gameID: gameID,
                    mood: mood,
                    note: trimmedNote.isEmpty ? nil : trimmedNote,
                    durationMinutes: durationMinutes,
                    date: date
                )
            }
                saveState = .saved
                print("saved")
        } catch {
            print("error")
            saveState = .error(error.localizedDescription)
        }
    }
    
    func delete() -> Bool {
        guard let existingSession else { return false }
        do {
            try repository.delete(id: existingSession.id)
            return true
        } catch {
            saveState = .error(error.localizedDescription)
            return false
        }
    }
}
