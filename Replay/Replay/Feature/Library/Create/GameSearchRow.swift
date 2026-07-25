//
//  GameSearchRow.swift
//  Replay
//
//  Created by Anandhakrishnan on 17/07/26.
//

import SwiftUI

enum SearchAddButtonState: Equatable {
    case idle
    case adding
    case added
}

struct GameSearchRow: View {
    let result: GameSearchResult
    let onAdd: () async -> Void

    @State private var buttonState: SearchAddButtonState = .idle

    var body: some View {
        HStack(spacing: 12) {
            coverImage

            VStack(alignment: .leading, spacing: 6) {
                Text(result.title)
                    .font(AppFont.semibold.withSize(16))
                    .foregroundStyle(.white)
                    .lineLimit(1)

                metaRow
            }

            Spacer()

            addButton
        }
        .padding(.vertical, 8)
    }

    // MARK: - Cover

    @ViewBuilder
    private var coverImage: some View {
        AsyncImage(url: result.coverURL) { phase in
            switch phase {
            case .success(let image):
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            default:
                placeholderCover
            }
        }
        .frame(width: 56, height: 76)
        .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
    }

    private var placeholderCover: some View {
        RoundedRectangle(cornerRadius: 8, style: .continuous)
            .fill(.white.opacity(0.06))
            .overlay(
                Image(systemName: "photo")
                    .foregroundStyle(.white.opacity(0.25))
            )
    }

    // MARK: - Genre pill + year

    @ViewBuilder
    private var metaRow: some View {
        HStack(spacing: 6) {
            if let genre = result.genre {
                Text(genre)
                    .font(AppFont.regular.withSize(12))
                    .foregroundStyle(.white.opacity(0.85))
                    .padding(.horizontal, 8)
                    .padding(.vertical, 3)
                    .background(.white.opacity(0.1), in: RoundedRectangle(cornerRadius: 6, style: .continuous))
            }

            if let year = result.displayYear {
                Text(result.genre != nil ? "· \(String(year))" : String(year))
                    .font(AppFont.regular.withSize(12))
                    .foregroundStyle(.white.opacity(0.5))
            }
        }
    }

    // MARK: - Add button

    @ViewBuilder
    private var addButton: some View {
        Button {
            Task { await handleAdd() }
        } label: {
            ZStack {
                Circle()
                    .fill(.white.opacity(0.08))
                    .frame(width: 36, height: 36)

                switch buttonState {
                case .idle:
                    Image(systemName: "plus")
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundStyle(.white.opacity(0.8))
                case .adding:
                    ProgressView()
                        .tint(.white)
                        .scaleEffect(0.7)
                case .added:
                    Image(systemName: "checkmark")
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundStyle(.green)
                }
            }
        }
        .disabled(buttonState != .idle)
        .animation(.bouncy, value: buttonState)
    }

    private func handleAdd() async {
        buttonState = .adding
        await onAdd()
        buttonState = .added

        try? await Task.sleep(for: .seconds(1.2))
        buttonState = .idle
    }
}
