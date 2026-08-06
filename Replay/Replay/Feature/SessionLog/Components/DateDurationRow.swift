//
//  DateDurationRow.swift
//  Replay
//
//  Created by Anandhakrishnan on 27/07/26.
//

import SwiftUI

struct DateDurationRow: View {
    @Binding var sessionDate: Date
    @Binding var durationMinutes: Int

    @State private var showDatePicker = false

    var body: some View {
        VStack(spacing: 24) {
            dateCard
            durationCard
        }
    }

    // MARK: Date

    // DateDurationRow.swift — replace the custom Button + popover with:

    private var dateCard: some View {
        cardContainer {
            VStack(alignment: .leading, spacing: 6) {
                Text("DATE")
                    .font(.caption2.bold())
                    .foregroundStyle(.white.opacity(0.4))

                HStack(spacing: 6) {
                    Image(systemName: "calendar")
                        .foregroundStyle(.purple)

                    DatePicker(
                        "Session Date",
                        selection: $sessionDate,
                        displayedComponents: .date
                    )
//                    .labelsHidden()
                    .datePickerStyle(.compact)
                    .tint(.purple)
                    .colorScheme(.dark)
                }
            }
        }
    }
    private var formattedDate: String {
        if Calendar.current.isDateInToday(sessionDate) {
            return "Today"
        }
        return sessionDate.formatted(date: .abbreviated, time: .omitted)
    }

    // MARK: Duration

    private var durationCard: some View {
        cardContainer {
            VStack(alignment: .leading, spacing: 6) {
                Text("DURATION")
                    .font(.caption2.bold())
                    .foregroundStyle(.white.opacity(0.4))

                HStack(spacing: 8) {
                    Image(systemName: "clock")
                        .foregroundStyle(.purple)
                    Text("\(durationMinutes)m")
                        .foregroundStyle(.white)

                    Spacer()

                    stepperButton(systemImage: "minus") {
                        durationMinutes = max(10, durationMinutes - 10)
                    }
                    stepperButton(systemImage: "plus") {
                        durationMinutes += 10
                    }
                }
            }
        }
    }

    private func stepperButton(systemImage: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Image(systemName: systemImage)
                .font(.system(size: 12, weight: .bold))
                .foregroundStyle(.white)
                .frame(width: 28, height: 28)
                .background(Circle().fill(Color.white.opacity(0.1)))
        }
        .buttonStyle(.plain)
    }

    // MARK: Shared card shell

    @ViewBuilder
    private func cardContainer<Content: View>(@ViewBuilder content: () -> Content) -> some View {
        content()
            .padding(14)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.white.opacity(0.05))
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(Color.white.opacity(0.1), lineWidth: 1)
                    )
            )
    }
}
