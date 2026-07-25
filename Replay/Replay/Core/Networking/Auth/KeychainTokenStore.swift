//
//  KeychainTokenStore.swift
//  Replay
//
//  Created by Anandhakrishnan on 13/07/26.
//

import Foundation
import Security

struct TokenEntry: Codable {
    let token: String
    let expiresAt: Date
}

enum KeychainTokenStoreError: Error {
    case encodingFailed
    case decodingFailed
    case unexpectedStatus(OSStatus)
}

final class KeychainTokenStore {
    private let service: String
    private let account: String
    
    init(service: String = "\(Bundle.main.bundleIdentifier ?? "app").igdb", account: String = "twitchAppToken") {
        self.service = service
        self.account = account
    }
    
    func save(_ entry: TokenEntry) throws {
        
        guard let data = try? JSONEncoder().encode(entry) else {
            throw KeychainTokenStoreError.encodingFailed
        }
        
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: account,
        ]
        
        // Remove any existing entry first — simpler and safer than add-vs-update branching.
        SecItemDelete(query as CFDictionary)
        
        var newItem = query
        newItem[kSecValueData as String] = data
        newItem[kSecAttrAccessible as String] = kSecAttrAccessibleAfterFirstUnlock
        
        let status = SecItemAdd(newItem as CFDictionary, nil)
        guard status == errSecSuccess else {
            throw KeychainTokenStoreError.unexpectedStatus(status)
        }
    }
    
    func load() throws -> TokenEntry? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: account,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        
        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)
        if status == errSecItemNotFound {
            return nil
        }
        guard status == errSecSuccess, let data = result as? Data else {
            throw KeychainTokenStoreError.unexpectedStatus(status)
        }
        guard let entry = try? JSONDecoder().decode(TokenEntry.self, from: data) else {
            throw KeychainTokenStoreError.decodingFailed
        }
        return entry
    }
    
    func delete() throws {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: account,
        ]
        
        let status = SecItemDelete(query as CFDictionary)
        guard status == errSecSuccess || status == errSecItemNotFound else {
            throw KeychainTokenStoreError.unexpectedStatus(status)
        }
    }
}
