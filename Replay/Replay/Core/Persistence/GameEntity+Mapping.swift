//
//  GameEntity+Mapping.swift
//  Replay
//
//  Created by Anandhakrishnan on 30/06/26.
//

import CoreData

extension GameEntity {
    func toDomain() -> Game {
        Game(
            id: id ?? UUID(),
            title: title ?? "",
            coverURL: coverUrl,
            platform: platform,
            releaseDate: releaseDate,
            igdbID: igdbId == 0 ? nil : igdbId,
            dateAdded: dateAdded ?? .now,
            sessions: []
//            sessions: (sessions as? Set<SessionEntity>)?
//                .map { $0.toDomain() }
//                .sorted { $0.date > $1.date } ?? []
        )
    }
}
