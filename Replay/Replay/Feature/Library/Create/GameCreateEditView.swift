//
//  GameCreateEditView.swift
//  Replay
//
//  Created by Anandhakrishnan on 30/06/26.
//

import SwiftUI

struct AddEditGameView: View {
    @State private var viewModel: AddEditGameViewModel
    @Environment(\.dismiss) private var dismiss

    init(game: Game? = nil) {
        _viewModel = State(initialValue: AddEditGameViewModel(game: game))
    }

    var body: some View {
        VStack {
            
        }
        .sheetBackgroundGradient()
    }
}
