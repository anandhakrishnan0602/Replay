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
                    GameTile(game: game)
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
            let authProvider = TwitchAuthProvider(
                clientID: AppSecrets.igdbClientID,
                clientSecret: AppSecrets.igdbClientSecret
            )
            do {
                let token = try await authProvider.validToken()
                print("Got token: \(token.prefix(10))...") // don't print the full token either
            } catch {
                print("Token fetch failed: \(error)")
            }
            viewModel.loadGames()
        }
    }
}

struct GameTile: View {
    var game: Game
    var body: some View {
        HStack() {
            Image("game")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 100, height: 100)
                .background(Color.white)
            VStack(alignment: .leading) {
                Text(game.title)
                    .font(AppFont.semibold.withSize(20))
                Text(game.platform ?? "no platform")
                    .font(AppFont.semibold.withSize(14))
                Text("last played 5h ago")
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
