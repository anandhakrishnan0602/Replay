//
//  Session.swift
//  Replay
//
//  Created by Anandhakrishnan on 30/06/26.
//
import Foundation

struct Session: Identifiable, Hashable {
    let id: UUID
    var date: Date
    var mood: Mood
    var note: String?
    var durationMinutes: Int?
}
