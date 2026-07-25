//
//  GameCreateEditView.swift
//  Replay
//
//  Created by Anandhakrishnan on 30/06/26.
//

import SwiftUI

struct AddEditGameView: View {
    @State private var viewModel: AddGameSearchViewModel
    @Environment(\.dismiss) private var dismiss
    
    init(game: Game? = nil) {
        _viewModel = State(initialValue: AddGameSearchViewModel())
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
            SearchBar(text: $viewModel.searchText)
            
            ScrollView {
                LazyVStack(spacing: 0) {
                    ForEach(viewModel.searchResults) { result in
                        GameSearchRow(result: result) {
                            await viewModel.addGame(from: result)
                        }

                        if result.id != viewModel.searchResults.last?.id {
                            Divider()
                                .overlay(.white.opacity(0.06))
                                .padding(.leading, 68) // aligns with text, not under the cover
                        }
                    }
                }
                .padding(.horizontal)
            }
            
        }
        .sheetBackgroundGradient()
    }
}

#Preview {
    AddEditGameView()
}
