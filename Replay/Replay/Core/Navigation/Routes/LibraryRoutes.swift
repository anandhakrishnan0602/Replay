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
    case SessionLog(game: Game, session: Session?)

    @ViewBuilder
    func view() -> some View {
        switch self {
        case .library:
            LibraryView()
        case .addEditGame(let game):
            AddEditGameView(game: game)
        case .details(game: let game):
            DetailsView(game: game)
        case .SessionLog(game: let game, session: let session):
            SessionLogSheet(game: game, session: session)
        }
    }
}
