//
//  GameSearchResult.swift
//  Replay
//
//  Created by Anandhakrishnan on 13/07/26.
//

import Foundation

struct GameSearchResult: Identifiable {
    let id: Int
    let title: String
    let coverURL: URL?
    let genre: String?
    let releaseDate: Date?
}

extension GameSearchResult {
    var displayYear: Int? {
        guard let releaseDate else { return nil }
        return Calendar.current.component(.year, from: releaseDate)
    }
}
