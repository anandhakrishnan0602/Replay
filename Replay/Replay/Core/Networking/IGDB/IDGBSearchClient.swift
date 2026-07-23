//
//  IDGBSearchClient.swift
//  Replay
//
//  Created by Anandhakrishnan on 15/07/26.
//


import Foundation

protocol GameSearching {
    func search(query: String) async throws -> [GameSearchResult]
}

final class IGDBSearchClient: GameSearching {
    
    private let authProvider: AuthTokenProviding
    private let clientID: String
    private let urlSession: URLSession
    private let baseURL = URL(string: "https://api.igdb.com/v4/games")!

    init(
        authProvider: AuthTokenProviding,
        clientID: String,
        urlSession: URLSession = .shared
    ) {
        self.authProvider = authProvider
        self.clientID = clientID
        self.urlSession = urlSession
    }

    
    func search(query: String) async throws -> [GameSearchResult] {
        let token = try await authProvider.validToken()
        
        var request = URLRequest(url: baseURL)
        request.httpMethod = "POST"
        request.setValue(clientID, forHTTPHeaderField: "Client-ID")
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        let body = #"search "\#(query)"; fields id, name, cover.url, genres.name, first_release_date; limit 10;"#
        request.httpBody = body.data(using: .utf8)
        let (data, response) = try await urlSession.data(for: request)
        guard let http = response as? HTTPURLResponse, http.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
        
        let dtos = try JSONDecoder().decode([IGDBGameDTO].self, from: data)
        return dtos.map { $0.toSearchResult() }
    }
}
