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
    var sessions: [Session]
}
