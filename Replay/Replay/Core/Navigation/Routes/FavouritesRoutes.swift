//
//  FavouritesRoutes.swift
//  movie_browser
//
//  Created by anandhakrishnan on 01/12/25.
//

import SwiftUI

enum FavouritesRoutes: RouteProtocol {

    case favorite
    case detail(movie: Movie)

    @ViewBuilder
    func view() -> some View {
        switch self {
        case .favorite: FavouritesView()
        case .detail(let movie):
            DetailView(movie: movie)
        }
    }
}
