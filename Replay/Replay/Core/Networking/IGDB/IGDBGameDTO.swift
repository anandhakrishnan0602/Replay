//
//  IGDBGameDTO.swift
//  Replay
//
//  Created by Anandhakrishnan on 13/07/26.
//

import Foundation

struct IGDBGameDTO: Decodable {
    let id: Int
    let name: String
    let cover: Cover?
    let genres: [Genre]?
    let first_release_date: Int?

    struct Cover: Decodable {
        let url: String
    }

    struct Genre: Decodable {
        let name: String
    }
}


extension IGDBGameDTO {
    func toSearchResult() -> GameSearchResult {
        GameSearchResult(
            id: id,
            title: name,
            coverURL: Self.transformedCoverURL(from: cover?.url),
            genre: genres?.first?.name,
            releaseDate: Self.releaseDate(from: first_release_date),
        )
    }

    private static func transformedCoverURL(from rawURL: String?) -> URL? {
        guard let rawURL else { return nil }
        let httpsURL = "https:" + rawURL
        let resized = httpsURL.replacingOccurrences(of: "t_thumb", with: "t_cover_small")
        return URL(string: resized)
    }
    
    private static func releaseDate(from timestamp: Int?) -> Date? {
        guard let timestamp else { return nil }
        return Date(timeIntervalSince1970: TimeInterval(timestamp))
    }
}
