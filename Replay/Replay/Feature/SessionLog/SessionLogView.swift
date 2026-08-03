//
//  SessionLogView.swift
//  Replay
//
//  Created by Anandhakrishnan on 27/07/26.
//

// Features/QuickLog/QuickLogSheet.swift

import SwiftUI

struct SessionLogSheet: View {
    @Environment(\.dismiss) private var dismiss
    
    let game: Game
    
    @State private var viewModel: SessionLogViewModel
    @State private var showDeleteConfirmation = false

    
    init(game: Game, session: Session? = nil) {
        self.game = game
        viewModel = SessionLogViewModel(gameID: game.id, session: session)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            header
            
            MoodSelectorRow(selectedMood: $viewModel.mood)
            SessionNotesEditor(text: $viewModel.note)
            DateDurationRow(sessionDate: $viewModel.date, durationMinutes: $viewModel.durationMinutes)
            VStack(alignment: .leading, spacing: 8) {
                SaveSessionButton(state: viewModel.saveState, isEditing: viewModel.isEditing) {
                    viewModel.save()
                }

                if case .error(let message) = viewModel.saveState {
                    Text(message)
                        .font(.footnote)
                        .foregroundStyle(.red)
                }
            }
            Spacer()
        }
        .padding(.horizontal, 20)
        .padding(.top, 40)
        .backgroundGradient()
        .presentationDragIndicator(.visible)
        .onChange(of: viewModel.saveState) { _, newState in
            if newState == .saved {
                Task {
                    try? await Task.sleep(for: .seconds(0.6))
                    dismiss()
                }
            }
        }
        .alert("Delete this session?", isPresented: $showDeleteConfirmation) {
            Button("Cancel", role: .cancel) {}
            Button("Delete", role: .destructive) {
                if viewModel.delete() {
                    dismiss()
                }
            }
        } message: {
            Text("This can't be undone.")
        }
    }
    
    private var header: some View {
        HStack {
            Text("Log Session")
                .font(.title2.bold())
                .foregroundStyle(.white)
            
            Spacer()
            
            if viewModel.isEditing {
                Button {
                    showDeleteConfirmation = true
                } label: {
                    Image(systemName: "trash")
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundStyle(.red)
                        .frame(width: 36, height: 36)
                        .glassEffect(.regular, in: .circle)
                }
            }
            
            Button {
                dismiss()
            } label: {
                Image(systemName: "xmark")
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundStyle(.white)
                    .frame(width: 36, height: 36)
                    .glassEffect(.regular, in: .circle)
            }
        }
    }
}

#Preview {
    Color.black
        .sheet(isPresented: .constant(true)) {
//            SessionLogSheet()
        }
}
