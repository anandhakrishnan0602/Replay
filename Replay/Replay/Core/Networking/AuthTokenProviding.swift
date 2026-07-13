//
//  AuthTokenProviding.swift
//  Replay
//
//  Created by Anandhakrishnan on 13/07/26.
//

import Foundation

protocol AuthTokenProviding {
    /// Returns a valid, non-expired token — fetching or refreshing internally if needed.
    func validToken() async throws -> String
}
