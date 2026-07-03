//
//  ReplayApp.swift
//  Replay
//
//  Created by Anandhakrishnan on 29/06/26.
//

import SwiftUI
import CoreData

@main
struct ReplayApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
