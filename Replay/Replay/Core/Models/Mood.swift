//
//  Mood.swift
//  Replay
//
//  Created by Anandhakrishnan on 30/06/26.
//

import Foundation

enum Mood: String, CaseIterable, Identifiable {
    case neutral, thrilled, frustrated, relaxed, immersed, bored, disappointed

    var id: String { rawValue }

    var emoji: String {
        switch self {
        case .neutral: "😐"
        case .thrilled: "🤩"
        case .frustrated: "😤"
        case .relaxed: "😌"
        case .immersed: "🤯"
        case .bored: "😑"
        case .disappointed: "😞"
        }
    }

    var label: String {
        switch self {
        case .neutral: "Neutral"
        case .thrilled: "Thrilled"
        case .frustrated: "Frustrated"
        case .relaxed: "Relaxed"
        case .immersed: "Immersed"
        case .bored: "Bored"
        case .disappointed: "Disappointed"
        }
    }
}
