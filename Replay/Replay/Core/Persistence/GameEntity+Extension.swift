//
//  GameEntity+Extension.swift
//  Replay
//
//  Created by Anandhakrishnan on 30/06/26.
//

import Foundation
import CoreData
extension GameEntity {
    public override nonisolated func awakeFromInsert() {
        super.awakeFromInsert()
        id = UUID()
        dateAdded = .now
    }
}
