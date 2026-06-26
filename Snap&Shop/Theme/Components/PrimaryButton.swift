//
//  PrimaryButton.swift
//  Snap&Shop
//
//  Created by ETEFWORKIE MELAKU on 2026-06-26.
//

import SwiftUI

/// Full-width accent-colored button with 50 pt touch target.
/// Set `isLoading` to swap the label for a spinner while an async operation is in-flight.
struct PrimaryButton: View {
    let title: String
    var isLoading: Bool = false
    var isDisabled: Bool = false
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            ZStack {
                if isLoading {
                    ProgressView()
                        .progressViewStyle(.circular)
                        .tint(Color.Brand.accentOn)
                } else {
                    Text(title)
                        .font(Typography.callout.weight(.semibold))
                        .foregroundStyle(Color.Brand.accentOn)
                }
            }
            .frame(maxWidth: .infinity)
            .frame(height: 50)
            .background(
                (isDisabled || isLoading) ? Color.Brand.accent.opacity(0.4) : Color.Brand.accent
            )
            .clipShape(RoundedRectangle(cornerRadius: Radius.pill))
        }
        .disabled(isDisabled || isLoading)
    }
}

#Preview("Default") {
    PrimaryButton(title: "Search for prices") {}
        .padding()
}

#Preview("Loading") {
    PrimaryButton(title: "Searching…", isLoading: true) {}
        .padding()
}

#Preview("Disabled") {
    PrimaryButton(title: "Search for prices", isDisabled: true) {}
        .padding()
}
