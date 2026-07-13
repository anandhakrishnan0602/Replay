//
//  SheetBackgroundGradient.swift
//  Replay
//
//  Created by Anandhakrishnan on 08/07/26.
//

import SwiftUI

struct SheetBackgroundGradientModifier: ViewModifier {
    func body(content: Content) -> some View {
        ZStack {
            LinearGradient(
                colors: [
                    Color("SheetBackgroundTop"), // very slightly lifted navy at top
                    Color("SheetBackgroundMid"), // near-black
                    Color.black,.black,  // pure black
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            content
        }
    }
}

extension View {
    func sheetBackgroundGradient() -> some View {
        modifier(SheetBackgroundGradientModifier())
    }
}
