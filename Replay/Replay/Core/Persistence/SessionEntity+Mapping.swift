//
//  SessionEntity+Mapping.swift
//  Replay
//
//  Created by Anandhakrishnan on 03/07/26.
//

import CoreData

extension SessionEntity {
    func toDomain() -> Session {
        Session(
            id: id ?? UUID(),
            date: date ?? .now,
            mood: Mood(rawValue: mood ?? "") ?? .neutral,
            note: note,
            durationMinutes: durationMinutes == 0 ? nil : Int(durationMinutes)
        )
    }
}
