//
//  ProfileRoutes.swift
//  movie_browser
//
//  Created by anandhakrishnan on 01/12/25.
//

import SwiftUI

enum ProfileRoutes: RouteProtocol {

    case profile
    case detail(movie: Movie)

    @ViewBuilder
    func view() -> some View {
        switch self {
        case .profile: ProfileView()
        case .detail(let movie):
            DetailView(movie: movie)
        }
    }
}
