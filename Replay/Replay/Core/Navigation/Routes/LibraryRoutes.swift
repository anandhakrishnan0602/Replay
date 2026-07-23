//
//  LibraryRoutes.swift
//  Replay
//
//  Created by Anandhakrishnan on 03/07/26.
//

import SwiftUI

enum LibraryRoutes: RouteProtocol {
    case library
    case addEditGame(game: Game?)
    case details(game: Game)

    @ViewBuilder
    func view() -> some View {
        switch self {
        case .library:
            LibraryView()
        case .addEditGame(let game):
            AddEditGameView(game: game)
        case .details(game: let game):
            DetailsView()
        }
    }
}
