//
//  Date+Extensions.swift
//  Replay
//
//  Created by Anandhakrishnan on 25/07/26.
//

import Foundation

extension Date {
    var yearString: String {
        let calendar = Calendar.current
        let year = calendar.component(.year, from: self)
        return String(year)
    }
    
    var monthAbbreviation: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM"
        return formatter.string(from: self).uppercased()
    }

    var dayNumber: String {
        let calendar = Calendar.current
        return String(calendar.component(.day, from: self))
    }
}
