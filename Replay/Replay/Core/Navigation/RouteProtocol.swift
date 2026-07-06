//
//  RouteProtocol.swift
//  movie_browser
//
//  Created by anandhakrishnan on 01/12/25.
//

import SwiftUI

protocol RouteProtocol: Hashable {
    associatedtype Screen: View
    @ViewBuilder func view() -> Screen
}
