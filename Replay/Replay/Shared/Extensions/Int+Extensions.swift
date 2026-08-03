//
//  Int+Extensions.swift
//  Replay
//
//  Created by Anandhakrishnan on 30/07/26.
//

extension Int {
    var formattedDuration: String {
        let hours = self / 60
        let minutes = self % 60
        if hours > 0 && minutes > 0 {
            return "\(hours)h \(minutes)m"
        } else if hours > 0 {
            return "\(hours)h"
        } else {
            return "\(minutes)m"
        }
    }
}
