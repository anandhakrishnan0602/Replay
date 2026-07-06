//
//  QuickLogSheet.swift
//  Replay
//
//  Created by Anandhakrishnan on 03/07/26.
//

import SwiftUI

struct QuickLogSheet: View {
    
    @State private var viewModel: QuickLogViewModel
    @State private var showGamePicker = false
    @Environment(\.dismiss) private var dismiss
    
    let onComplete: () -> Void
    
    init(
        preselectedGame: Game?,
        sessionRepository: SessionRepository,
        gameRepository: GameRepository,
        onComplete: @escaping () -> Void
    ) {
        _viewModel = State(initialValue: QuickLogViewModel(
            sessionRepository: sessionRepository,
            gameRepository: gameRepository,
            preselectedGame: preselectedGame
        ))
        self.onComplete = onComplete
    }
    
    var body: some View {
        NavigationStack {
            Form {
                // MARK: Game picker section
                Section {
                    Button {
                        showGamePicker = true
                    } label: {
                        HStack {
                            Text(viewModel.selectedGame?.title ?? "Select a game")
                                .foregroundStyle(
                                    viewModel.selectedGame == nil
                                    ? .secondary : .primary
                                )
                            Spacer()
                            Image(systemName: "chevron.right")
                                .foregroundStyle(.tertiary)
                                .font(.caption)
                        }
                    }
                    .buttonStyle(.plain)
                } header: {
                    Text("Game")
                }
                
                // MARK: Mood section
                Section {
                    moodSelector
                } header: {
                    Text("How did it feel?")
                }
                
                // MARK: Note section
                Section {
                    TextField("One line about this session...", text: $viewModel.note)
                        .submitLabel(.done)
                } header: {
                    Text("Note")
                } footer: {
                    Text("Optional")
                }
                
                // MARK: Duration section
                Section {
                    Toggle("Log duration", isOn: $viewModel.isDurationEnabled)
                    
                    if viewModel.isDurationEnabled {
                        Stepper(
                            "\(viewModel.durationMinutes) min",
                            value: $viewModel.durationMinutes,
                            in: 5...600,
                            step: 5
                        )
                    }
                } header: {
                    Text("Duration")
                } footer: {
                    Text("Optional — platforms already track this")
                }
                
                // MARK: Error
                if let error = viewModel.errorMessage {
                    Section {
                        Text(error)
                            .foregroundStyle(.red)
                            .font(.caption)
                    }
                }
            }
            .navigationTitle("Log Session")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    if viewModel.isLoading {
                        ProgressView()
                    } else {
                        Button("Log") {
                            viewModel.logSession {
                                dismiss()
                                onComplete()
                            }
                        }
                        .disabled(!viewModel.canSubmit)
                        .fontWeight(.semibold)
                    }
                }
            }
            .sheet(isPresented: $showGamePicker) {
                GamePickerSheet(
                    games: (try? viewModel.availableGames) ?? [],
                    onSelect: { viewModel.selectGame($0) }
                )
                .presentationDetents([.medium, .large])
            }
        }
        .presentationDetents([.large])
        .presentationDragIndicator(.visible)
    }
    
    // MARK: - Mood selector
    
    private var moodSelector: some View {
        HStack(spacing: 0) {
            ForEach(Mood.allCases) { mood in
                Button {
                    viewModel.selectMood(mood)
                } label: {
                    VStack(spacing: 4) {
                        Text(mood.emoji)
                            .font(.title2)
                        Text(mood.rawValue.capitalized)
                            .font(.caption2)
                            .foregroundStyle(
                                viewModel.selectedMood == mood
                                ? .primary : .secondary
                            )
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 8)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(
                                viewModel.selectedMood == mood
                                ? Color.accentColor.opacity(0.15)
                                : Color.clear
                            )
                    )
                }
                .buttonStyle(.plain)
            }
        }
    }
}
