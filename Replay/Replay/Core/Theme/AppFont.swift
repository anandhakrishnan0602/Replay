//
//  AppFont.swift
//  Replay
//
//  Created by Anandhakrishnan on 08/07/26.
//
import SwiftUI

enum AppFont {
    case regular
    case medium
    case semibold
    case bold

    var weight: Font.Weight {
        switch self {
        case .regular: .regular
        case .medium: .medium
        case .semibold: .semibold
        case .bold: .bold
        }
    }

    func withSize(_ size: Int) -> Font {
        .system(size: CGFloat(size), weight: weight)
    }
}
