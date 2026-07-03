//
//  GameCreateEditView.swift
//  Replay
//
//  Created by Anandhakrishnan on 30/06/26.
//

import SwiftUI

struct AddEditGameView: View {
    @State private var viewModel: AddEditGameViewModel
    @Environment(\.dismiss) private var dismiss

    init(game: Game? = nil) {
        _viewModel = State(initialValue: AddEditGameViewModel(game: game))
    }

    var body: some View {
        NavigationStack {
            Form {
                Section("Details") {
                    TextField("Title", text: $viewModel.title)
                    TextField("Platform", text: $viewModel.platform)
                    TextField("Cover Image URL", text: $viewModel.coverURLText)
                        .keyboardType(.URL)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()
                }

                Section("Release Date") {
                    Toggle("Has release date", isOn: $viewModel.hasReleaseDate)
                    if viewModel.hasReleaseDate {
                        DatePicker("Release Date", selection: $viewModel.releaseDate, displayedComponents: .date)
                    }
                }

                Section("IGDB") {
                    TextField("IGDB ID", text: $viewModel.igdbIDText)
                        .keyboardType(.numberPad)
                }

                if let errorMessage = viewModel.errorMessage {
                    Section {
                        Text(errorMessage)
                            .foregroundStyle(.red)
                    }
                }
            }
            .navigationTitle(viewModel.navigationTitle)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button(viewModel.isEditing ? "Save" : "Add") {
                        if viewModel.save() {
                            print("saved")
                            dismiss()
                        }
                    }
                    .disabled(!viewModel.isValid || viewModel.isSaving)
                }
            }
        }
    }
}
