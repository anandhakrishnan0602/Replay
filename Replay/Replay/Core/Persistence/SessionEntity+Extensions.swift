//
//  SessionEntity+Extensions.swift
//  Replay
//
//  Created by Anandhakrishnan on 30/06/26.
//

import CoreData

extension SessionEntity {
    public override nonisolated func awakeFromInsert() {
        super.awakeFromInsert()
        id = UUID()
        date = .now
    }
}
