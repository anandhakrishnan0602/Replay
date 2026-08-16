//
//  Toast.swift
//  Replay
//
//  Created by Anandhakrishnan on 07/08/26.
//

// Core/Components/ToastView.swift

import SwiftUI

struct ToastView: View {
    let message: String

    var body: some View {
        Text(message)
            .font(.subheadline.weight(.medium))
            .foregroundStyle(.black)
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(Color.white.opacity(0.8), in: Capsule())
            .padding(.horizontal, 40)
            .padding(.bottom, 50)
            .transition(.move(edge: .bottom).combined(with: .opacity))
    }
}

import SwiftUI

extension View {
    func toast(message: Binding<String?>) -> some View {
        ZStack(alignment: .bottom) {
            self
            if let text = message.wrappedValue {
                ToastView(message: text)
                    .task {
                            try? await Task.sleep(for: .seconds(5))
                            message.wrappedValue = nil
                        }
            }
        }
        .animation(.bouncy(duration: 0.4, extraBounce: 0.15), value: message.wrappedValue)
    }
}
