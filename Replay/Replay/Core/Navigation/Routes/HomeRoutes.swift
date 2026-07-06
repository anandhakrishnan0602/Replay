//
//  HomeRoutes.swift
//  movie_browser
//
//  Created by anandhakrishnan on 01/12/25.
//

import SwiftUI

enum HomeRoutes: RouteProtocol {

    case home
    case detail(movie: Movie)

    @ViewBuilder
    func view() -> some View {
        switch self {
        case .home: HomeView()
        case .detail(let movie):
            DetailView(movie: movie)
        }
    }
}
