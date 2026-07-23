//
//  LibraryView.swift
//  Replay
//
//  Created by Anandhakrishnan on 30/06/26.
//

import SwiftUI

struct LibraryView: View {
    
    @Environment(Navigator<LibraryRoutes>.self) var navigator
    
    @State private var viewModel: LibraryViewModel = LibraryViewModel()
    @State private var showQuickLog = false
    @State private var selectedGame: Game?
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 10) {
                ForEach(viewModel.games) { game in
                    GameTile(game: game) { id in
                        viewModel.deleteGame(id: id)
                    }
                        .padding(.horizontal, 10)
                        .onTapGesture {
                            self.selectedGame = game
                            self.showQuickLog.toggle()
                        }
                }
            }
            .sheet(isPresented: $showQuickLog) {
                
            }
        }
        .backgroundGradient()
        .navigationTitle(Text("Library"))
        .searchable(text: $viewModel.searchText, prompt: "Search for game") {
            
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button{
                    navigator.presentSheet(LibraryRoutes.addEditGame(game: nil))
                }
                label: {
                    Image(systemName: "plus")
                }
            }
        }
        .task {
            viewModel.loadGames()
        }
    }
}

struct GameTile: View {
    var game: Game
    var remove: (UUID)->Void
    var body: some View {
        HStack() {
            
            AsyncImage(url: game.coverURL) { phase in
                switch phase {
                case .empty:
                    ProgressView()
                case .success(let image):
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                case .failure:
                    Image(systemName: "photo")
                        .foregroundStyle(.gray)
                @unknown default:
                    EmptyView()
                }
            }
            .frame(width: 100, height: 140) // match your cover art tile size
            .clipShape(RoundedRectangle(cornerRadius: 8))
            
            VStack(alignment: .leading) {
                Text(game.title)
                    .font(AppFont.semibold.withSize(20))
                Text(game.genre ?? "no genre")
                    .font(AppFont.semibold.withSize(14))
                Text("last played 5h ago")
                    .font(AppFont.regular.withSize(14))
            }
            Spacer()
            Button {
                remove(game.id)
            } label: {
                Text("clear")
            }
        }
        .foregroundStyle(Color.white)
    }
}
// MARK: - Preview

#Preview {
    //    let controller = PersistenceController.preview
    //    let repository = GameRepository(context: controller.context)
    //    let viewModel = LibraryViewModel(repository: repository)
    LibraryView()
    
}
