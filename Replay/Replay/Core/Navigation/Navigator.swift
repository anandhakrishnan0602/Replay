//
//  Navigator.swift
//  starterProjectSwiftUI
//
//  Created by anandhakrishnan on 18/12/24.
//

import SwiftUI

@Observable
class Navigator<R: RouteProtocol> {

    var navigationPath: [R] = []

    var startingPath: R
    
    var sheetItem: SheetItem<R>?

    init(startingPath: R) {
        self.startingPath = startingPath
    }

    func navigateTo(_ route: R) {
        navigationPath.append(route)
    }
    
    func presentSheet(_ route: R) {
        sheetItem = SheetItem(route: route)
    }

    func pop() {
        guard !navigationPath.isEmpty else { return }
        navigationPath.removeLast()
    }
    
    func dismissSheet() {
        sheetItem = nil
    }

    func setRoot(_ route: R) {
        startingPath = route
        navigationPath.removeAll()
    }
}

enum NavigationStacks {
    case library
    
    @ViewBuilder
    func view() -> some View {
        switch self {
        case .library:
            NavigationContainer(startRoute: LibraryRoutes.library)
        }
    }
}

struct NavigationContainer<R: RouteProtocol>: View {

    @State private var navigator: Navigator<R>

    init(startRoute: R) {
        _navigator = State(initialValue: Navigator(startingPath: startRoute))
    }
    
    var body: some View {
        NavigationStack(path: $navigator.navigationPath) {
            navigator.startingPath.view()
                .environment(navigator)

            .navigationDestination(for: R.self) { route in
                route.view().environment(navigator)
            }
        }
        .sheet(item: $navigator.sheetItem) { item in
            item.route.view().environment(navigator)
        }
    }
}

struct SheetItem<R: RouteProtocol>: Identifiable {
    let id = UUID()
    let route: R
}
