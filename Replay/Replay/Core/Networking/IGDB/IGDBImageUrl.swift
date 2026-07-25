//
//  IGDBImageUrl.swift
//  Replay
//
//  Created by Anandhakrishnan on 25/07/26.
//

import Foundation

enum IGDBImageSize: String, CaseIterable {
    case thumb = "t_thumb"
    case coverSmall = "t_cover_small"
    case coverBig = "t_cover_big"
    case hd1080 = "t_1080p"

    func resized(_ urlString: String) -> String {
        var result = urlString
        for candidate in IGDBImageSize.allCases {
            if result.contains(candidate.rawValue) {
                result = result.replacingOccurrences(of: candidate.rawValue, with: self.rawValue)
                break
            }
        }
        return result
    }
}
