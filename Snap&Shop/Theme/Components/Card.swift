//
//  Card.swift
//  Snap&Shop
//
//  Created by ETEFWORKIE MELAKU on 2026-06-26.
//

import SwiftUI

/// Surface container with rounded corners and a 1 pt border.
/// The border is always present but more prominent in dark mode where the
/// surface-to-background contrast is lower.
struct Card<Content: View>: View {
    @ViewBuilder let content: Content

    var body: some View {
        content
            .background(Color.Brand.surface)
            .clipShape(RoundedRectangle(cornerRadius: Radius.card))
            .overlay(
                RoundedRectangle(cornerRadius: Radius.card)
                    .strokeBorder(Color.Brand.border, lineWidth: 1)
            )
    }
}

#Preview {
    Card {
        VStack(alignment: .leading, spacing: Spacing.sm) {
            Text("Sony WH-1000XM5")
                .font(Typography.headline)
                .foregroundStyle(Color.Brand.textPrimary)
            Text("Over-ear headphones · 0.92 confidence")
                .font(Typography.caption)
                .foregroundStyle(Color.Brand.textSecondary)
        }
        .padding(Spacing.lg)
    }
    .padding()
}
