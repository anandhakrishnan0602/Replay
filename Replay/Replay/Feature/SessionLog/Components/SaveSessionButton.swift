//
//  SaveSessionButton.swift
//  Replay
//
//  Created by Anandhakrishnan on 27/07/26.
//

import SwiftUI

struct SaveSessionButton: View {
    let state: SessionLogViewModel.SaveState
    let isEditing: Bool
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            content
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(
                    Capsule()
                        .fill(Color(red: 0.80, green: 0.78, blue: 0.98))
                )
        }
        .buttonStyle(.plain)
        .disabled(state == .saving || state == .saved)
    }

    @ViewBuilder
    private var content: some View {
        switch state {
        case .idle, .error:
            HStack(spacing: 8) {
                Text(isEditing ? "Update Session" : "Save Session")
                    .font(.headline.bold())
                Image(systemName: "sparkles")
                    .font(.subheadline.bold())
            }
            .foregroundStyle(.indigo)

        case .saving:
            ProgressView()
                .tint(.indigo)

        case .saved:
            HStack(spacing: 8) {
                Image(systemName: "checkmark")
                    .font(.subheadline.bold())
                Text(isEditing ? "Updated" : "Saved")
                    .font(.headline.bold())
            }
            .foregroundStyle(.indigo)
        }
    }
}
