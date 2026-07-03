//
//  GameCreateEditViewModel.swift
//  Replay
//
//  Created by Anandhakrishnan on 30/06/26.
//

import Foundation

@MainActor
@Observable
final class AddEditGameViewModel {
    var title: String = ""
    var platform: String = ""
    var coverURLText: String = ""
    var releaseDate: Date = .now
    var hasReleaseDate: Bool = false
    var igdbIDText: String = ""

    private(set) var isSaving = false
    var errorMessage: String?

    private let repository: GameRepository
    private let existingGame: Game?

    var isEditing: Bool { existingGame != nil }
    var navigationTitle: String { isEditing ? "Edit Game" : "Add Game" }

    var isValid: Bool {
        !title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    init(repository: GameRepository? = nil, game: Game? = nil) {
        self.repository = repository ?? GameRepository(context: PersistenceController.shared.context)
        self.existingGame = game

        if let game {
            title = game.title
            platform = game.platform ?? ""
            coverURLText = game.coverURL?.absoluteString ?? ""
            if let releaseDate = game.releaseDate {
                self.releaseDate = releaseDate
                hasReleaseDate = true
            }
            if let igdbID = game.igdbID {
                igdbIDText = String(igdbID)
            }
        }
    }

    @MainActor @discardableResult
    func save() -> Bool {
        guard isValid else {
            errorMessage = "Title is required."
            return false
        }

        isSaving = true
        defer { isSaving = false }

        let trimmedTitle = title.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedPlatform = platform.trimmingCharacters(in: .whitespacesAndNewlines)
        let coverURL = URL(string: coverURLText.trimmingCharacters(in: .whitespacesAndNewlines))
        let igdbID = Int64(igdbIDText.trimmingCharacters(in: .whitespacesAndNewlines))

        do {
            if let existingGame {
                var updated = existingGame
                updated.title = trimmedTitle
                updated.platform = trimmedPlatform.isEmpty ? nil : trimmedPlatform
                updated.coverURL = coverURL
                updated.releaseDate = hasReleaseDate ? releaseDate : nil
                updated.igdbID = igdbID
                _ = try repository.update(updated)
            } else {
                _ = try repository.create(
                    title: trimmedTitle,
                    coverURL: coverURL,
                    platform: trimmedPlatform.isEmpty ? nil : trimmedPlatform,
                    releaseDate: hasReleaseDate ? releaseDate : nil,
                    igdbID: igdbID
                )
            }
            return true
        } catch {
            errorMessage = "Couldn't save game: \(error.localizedDescription)"
            return false
        }
    }
}
