//
//  DetailsView.swift
//  Replay
//
//  Created by Anandhakrishnan on 22/07/26.
//

import SwiftUI

struct DetailsView: View {
    @Environment(Navigator<LibraryRoutes>.self) var navigator
    @State var viewModel: GameDetailViewModel
    @State private var isShowingDeleteConfirmation = false
    
    let game : Game
    
    init(game: Game) {
        self.game = game
        self.viewModel = GameDetailViewModel(game: game)
    }
    
    var body: some View {
        ZStack(alignment: .bottom) {
            
            ScrollView {
                VStack() {
                    GameDetailHeroView(game: game, onBack: {})
                        .padding(.bottom, 8)
                    GameStats(sessionCount: viewModel.sessionCount, averageMoodEmoji: viewModel.averageMoodEmoji, minutesPlayed: viewModel.totalMinutesPlayed)
                    SessionsListView(sessions: viewModel.sessions) {session in
                        navigator.presentSheet(.SessionLog(game: game, session: session)) {
                            viewModel.loadSessions()
                        }
                    }
                }
                .padding(.bottom, 98)
            }
            SessionButton() {
                navigator.presentSheet(.SessionLog(game: game, session: nil)) {
                    viewModel.loadSessions()
                }
            }
            .padding(.bottom, 22)
        }
        .gameDetailBackground()
        .toolbarBackground(.hidden, for: .navigationBar)
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("")
        .toolbarColorScheme(.dark, for: .navigationBar)
        .ignoresSafeArea(edges: [.top, .bottom])
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Menu {
                    Button(role: .destructive) {
                        isShowingDeleteConfirmation = true
                    } label: {
                        Label("Delete Game", systemImage: "trash")
                    }
                } label: {
                    Image(systemName: "ellipsis")
                        .foregroundStyle(.white)
                        .padding(8)
                }
            }
        }
        .alert("Delete \(game.title)?", isPresented: $isShowingDeleteConfirmation) {
            Button("Delete", role: .destructive) {
                let success = viewModel.deleteGame()
                if success {
                    navigator.pop()
                }
            }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("This will permanently delete \(viewModel.sessionCount) logged session\(viewModel.sessionCount == 1 ? "" : "s") for this game. This action cannot be undone.")
        }
        .toast(message: $viewModel.errorMessage)
        .task {
            viewModel.loadSessions()
        }
    }
}

struct GameDetailHeroView: View {
    let game: Game
    let onBack: () -> Void
    @State private var selectedImageURLString: String?
    
    var body: some View {
        ZStack(alignment: .bottomLeading) {
            GeometryReader { geometry in
                let minY = geometry.frame(in: .global).minY
                let stretchedHeight = minY > 0 ? 420 + minY : 420
                
                ZStack {
                    AsyncImage(url: URL(string: selectedImageURLString ?? "")) { phase in
                        switch phase {
                        case .success(let image):
                            image.resizable().scaledToFill()
                        default:
                            Rectangle().fill(Color.black)
                        }
                    }
                    .frame(width: geometry.size.width, height: stretchedHeight)
                    .clipped()
                    
                    LinearGradient(
                        stops: [
                            .init(color: .clear, location: 0.0),
                            .init(color: .black.opacity(0.55), location: 0.55),
                            .init(color: .black.opacity(0.85), location: 1.0)
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                    .frame(width: geometry.size.width, height: stretchedHeight)
                }
                .offset(y: minY > 0 ? -minY : 0)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(game.title)
                    .font(.system(size: 34, weight: .bold))
                    .foregroundStyle(.white)
                
                HStack(spacing: 8) {
                    Text(game.genre ?? "")
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(.white.opacity(0.8))
                    Text("•")
                        .foregroundStyle(.white.opacity(0.5))
                    Text(game.releaseDate?.yearString ?? "-")
                        .font(.subheadline)
                        .foregroundStyle(.white.opacity(0.8))
                }
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 20)
        }
        .frame(height: 420)
        .task {
            selectedImageURLString = resolveImageURL()
        }
    }
    
    private func resolveImageURL() -> String? {
        guard let cover = game.coverURL else { return nil }
        return IGDBImageSize.hd1080.resized(cover.absoluteString)
    }
}

#Preview {
    //    DetailsView()
}
