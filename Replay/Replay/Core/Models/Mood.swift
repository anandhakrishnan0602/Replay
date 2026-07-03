//
//  Mood.swift
//  Replay
//
//  Created by Anandhakrishnan on 30/06/26.
//

enum Mood: String, CaseIterable, Identifiable {
    case thrilled
    case satisfied
    case neutral
    case frustrated
    case disappointed

    var id: String { rawValue }

    var emoji: String {
        switch self {
        case .thrilled: "🤩"
        case .satisfied: "🙂"
        case .neutral: "😐"
        case .frustrated: "😤"
        case .disappointed: "😞"
        }
    }
}
