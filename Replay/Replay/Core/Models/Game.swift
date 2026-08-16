//
//  Game.swift
//  Replay
//
//  Created by Anandhakrishnan on 30/06/26.
//
import Foundation

struct Game: Identifiable, Hashable {
    let id: UUID
    var title: String
    var coverURL: URL?
    var platform: String?
    var releaseDate: Date?
    var igdbID: Int64?
    var dateAdded: Date
    var genre: String?
    var lastModified: Date?
    var sessions: [Session]
}

extension Game {
    var totalPlayTimeDisplay: String {
        guard !sessions.isEmpty else {
            return "Not played yet"
        }
        
        let totalMinutes = sessions.reduce(0) { $0 + ($1.durationMinutes ?? 0) }
        let hours = totalMinutes / 60
        let minutes = totalMinutes % 60
        
        switch (hours, minutes) {
        case (0, let m):
            return "\(m)m played"
        case (let h, 0):
            return "\(h)h played"
        default:
            return "\(hours)h \(minutes)m played"
        }
    }
}
