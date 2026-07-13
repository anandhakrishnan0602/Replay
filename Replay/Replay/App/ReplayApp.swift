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
    
    init() {
        configureNavigationBar()
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
    
    private func configureNavigationBar() {
        // Large title — white, bold
        let largeTitleAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.white,
            .font: UIFont.systemFont(ofSize: 34, weight: .bold)
        ]
        
        // Inline title — white, semibold
        let titleAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.white,
            .font: UIFont.systemFont(ofSize: 17, weight: .semibold)
        ]
        let appearance = UINavigationBarAppearance()
        
        // Transparent when at top (large title visible)
//        appearance.configureWithTransparentBackground()
        appearance.largeTitleTextAttributes = largeTitleAttributes
        appearance.titleTextAttributes = titleAttributes
        
        // Frosted glass when scrolled (inline title kicks in)
        let scrolledAppearance = UINavigationBarAppearance()
//        scrolledAppearance.configureWithDefaultBackground()
//        scrolledAppearance.backgroundColor = UIColor(
//            red: 0.05, green: 0.05, blue: 0.12, alpha: 0.85
//        )
//        scrolledAppearance.backgroundEffect = UIBlurEffect(style: .systemUltraThinMaterialDark)
        scrolledAppearance.largeTitleTextAttributes = largeTitleAttributes
        scrolledAppearance.titleTextAttributes = titleAttributes
        
        // Apply globally
        UINavigationBar.appearance().standardAppearance = scrolledAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
        UINavigationBar.appearance().compactAppearance = scrolledAppearance
//        UINavigationBar.appearance().tintColor = UIColor(
//            red: 0.6, green: 0.4, blue: 1.0, alpha: 1.0
//        ) // purple accent for back buttons and bar button items
    }
}
