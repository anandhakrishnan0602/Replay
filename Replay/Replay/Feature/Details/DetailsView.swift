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
                    GameStats(sessionCount: viewModel.sessionCount, averageMoodEmoji: viewModel.averageMoodEmoji, hoursPlayed: viewModel.totalHoursPlayed)
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
//        toolbar(.hidden, for: .navigationBar)
        .toolbarBackground(.hidden, for: .navigationBar)
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("")
        .toolbarColorScheme(.dark, for: .navigationBar)
        .ignoresSafeArea(edges: [.top, .bottom])
        .task {
            viewModel.loadSessions()
        }
    }
}

struct GameDetailHeroView: View {
    let game: Game
    let onBack: () -> Void

    private var resizedImageURLString: String? {
        guard let url = game.coverURL else { return nil }
        return IGDBImageSize.coverBig.resized(url.absoluteString)
    }

    var body: some View {
        ZStack(alignment: .bottomLeading) {
            GeometryReader { geometry in
                let minY = geometry.frame(in: .global).minY
                let stretchedHeight = minY > 0 ? 420 + minY : 420

                ZStack {
                    AsyncImage(url: URL(string: resizedImageURLString ?? "")) { phase in
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
    }
}

#Preview {
    //    DetailsView()
}
