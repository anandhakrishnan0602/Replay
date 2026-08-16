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
    
    var body: some View {
        Group {
            if viewModel.games.isEmpty {
                ContentUnavailableView(
                    "No Games Yet",
                    systemImage: "gamecontroller",
                    description: Text("Tap + to add your first game")
                )
                .foregroundStyle(Color.white)
            } else if viewModel.filteredGames.isEmpty {
                ContentUnavailableView.search(text: viewModel.searchText)
                    .foregroundStyle(Color.white)
            } else {
        ScrollView {
            LazyVStack(spacing: 10) {
                ForEach(viewModel.filteredGames) { game in
                    GameTile(game: game)
                    .padding(.horizontal, 10)
                    .onTapGesture {
                        navigator.navigateTo(.details(game: game))
                    }
                }
            }
        }
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
        .toast(message: $viewModel.errorMessage)
    }
}

struct GameTile: View {
    var game: Game
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
                Text(game.totalPlayTimeDisplay)
                    .font(AppFont.regular.withSize(14))
            }
            Spacer()
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
