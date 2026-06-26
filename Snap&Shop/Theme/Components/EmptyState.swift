//
//  EmptyState.swift
//  Snap&Shop
//
//  Created by ETEFWORKIE MELAKU on 2026-06-26.
//

import SwiftUI

/// Centered placeholder for empty lists and failed loads.
/// Designed to replace the inline `CenteredStateConfig` + `centeredState()`
/// pattern in ResultsView — parameters are compatible except `body` → `subtitle`.
struct EmptyState: View {
    let icon: String
    var iconColor: Color = .Brand.textSecondary
    let title: String
    let subtitle: String
    var actionLabel: String?
    var action: (() -> Void)?

    var body: some View {
        VStack(spacing: Spacing.xl) {
            Image(systemName: icon)
                .font(.system(size: 52))
                .foregroundStyle(iconColor)
            VStack(spacing: Spacing.sm) {
                Text(title)
                    .font(Typography.headline)
                    .foregroundStyle(Color.Brand.textPrimary)
                    .multilineTextAlignment(.center)
                Text(subtitle)
                    .font(Typography.body)
                    .foregroundStyle(Color.Brand.textSecondary)
                    .multilineTextAlignment(.center)
            }
            if let label = actionLabel, let handler = action {
                PrimaryButton(title: label, action: handler)
                    .padding(.horizontal, Spacing.xl)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(Spacing.xxl)
    }
}

#Preview("With action") {
    EmptyState(
        icon: "camera.viewfinder",
        title: "No results yet",
        subtitle: "Take a photo of any product to search prices across retailers.",
        actionLabel: "Open camera",
        action: {}
    )
}

#Preview("Error tint") {
    EmptyState(
        icon: "wifi.exclamationmark",
        iconColor: Color.Brand.error,
        title: "Couldn't load prices",
        subtitle: "Network connection lost. Check your Wi-Fi.",
        actionLabel: "Try again",
        action: {}
    )
}

#Preview("No action") {
    EmptyState(
        icon: "heart.slash",
        title: "Nothing saved",
        subtitle: "Items you bookmark from scan results will appear here."
    )
}
