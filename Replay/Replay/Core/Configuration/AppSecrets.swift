//
//  AppSecrets.swift
//  Replay
//
//  Created by Anandhakrishnan on 13/07/26.
//
import Foundation
enum AppSecrets {
    static var igdbClientID: String {
        Bundle.main.object(forInfoDictionaryKey: "IGDBClientID") as? String ?? ""
    }
    static var igdbClientSecret: String {
        Bundle.main.object(forInfoDictionaryKey: "IGDBClientSecret") as? String ?? ""
    }
}
