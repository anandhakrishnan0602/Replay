//
//  TwitchAuthProvider.swift
//  Replay
//
//  Created by Anandhakrishnan on 13/07/26.
//

import Foundation

actor TwitchAuthProvider: AuthTokenProviding {
    
    private let clientID: String
    private let clientSecret: String
    private let store: KeychainTokenStore
    private let urlSession: URLSession

    // Refresh a little early to avoid edge-of-expiry races.
    private let expiryBuffer: TimeInterval = 60 * 60 // 1 hour
    
    init(
         clientID: String,
         clientSecret: String,
         store: KeychainTokenStore = KeychainTokenStore(),
         urlSession: URLSession = .shared
     ) {
         self.clientID = clientID
         self.clientSecret = clientSecret
         self.store = store
         self.urlSession = urlSession
     }
    
    func validToken() async throws -> String {
        if let cached = try store.load(), cached.expiresAt.timeIntervalSinceNow > expiryBuffer {
            return cached.token
        }
        return try await fetchAndStoreNewToken()
    }
    
    private func fetchAndStoreNewToken() async throws -> String {
        guard var components = URLComponents(string: "https://id.twitch.tv/oauth2/token") else {
            throw URLError(.badURL)
        }
        
        components.queryItems = [
            URLQueryItem(name: "client_id", value: clientID),
            URLQueryItem(name: "client_secret", value: clientSecret),
            URLQueryItem(name: "grant_type", value: "client_credentials")
        ]
        
        guard let url = components.url else {
            throw URLError(.badURL)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        let (data, response) = try await urlSession.data(for: request)
        guard let http = response as? HTTPURLResponse, http.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
        
        struct TokenResponse: Decodable {
            let access_token: String
            let expires_in: TimeInterval
        }
        let decoded = try JSONDecoder().decode(TokenResponse.self, from: data)
        let entry = TokenEntry(
            token: decoded.access_token,
            expiresAt: Date().addingTimeInterval(decoded.expires_in)
        )
        try store.save(entry)
        return entry.token
    }
}
