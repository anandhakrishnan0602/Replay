//
//  LibraryView.swift
//  Replay
//
//  Created by Anandhakrishnan on 30/06/26.
//

import SwiftUI

struct LibraryView: View {
    
    @State private var viewModel: LibraryViewModel = LibraryViewModel()
    @State private var showQuickLog = false
    @State private var selectedGame: Game?
    
    var body: some View {
        
    }
}
// MARK: - Preview

#Preview {
    let controller = PersistenceController.preview
    let repository = GameRepository(context: controller.context)
    let viewModel = LibraryViewModel(repository: repository)
    LibraryView()
}
