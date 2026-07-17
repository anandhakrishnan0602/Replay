//
//  GameSearchResult.swift
//  Replay
//
//  Created by Anandhakrishnan on 13/07/26.
//

import Foundation

struct GameSearchResult: Identifiable {
    let id = UUID()
    let title: String
    let coverURL: URL?
    let genre: String?
    let year: Int?
}
