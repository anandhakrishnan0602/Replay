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
    @State private var searchText = ""
    
    
    init(game: Game? = nil) {
        _viewModel = State(initialValue: AddEditGameViewModel(game: game))
    }
    
    var body: some View {
        VStack {
            ZStack{
                Text("Add Game")
                    .foregroundStyle(Color.white)
                
                HStack {
                    Button{
                        dismiss()
                    } label: {
                        Text("Cancel")
                            .padding(4)
                        
                    }
                    .buttonStyle(.glass)
                    
                    Spacer()
                }
                
            }
            .padding(.horizontal)
            .padding(.top, 12)
            .padding(.bottom, 20)
            
            // Search bar
            SearchBar(text: $searchText)
            
        }
        .sheetBackgroundGradient()
    }
}

#Preview {
    AddEditGameView()
}
