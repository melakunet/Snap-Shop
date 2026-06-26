//
//  ConfidenceBadge.swift
//  Snap&Shop
//
//  Created by ETEFWORKIE MELAKU on 2026-06-26.
//

import SwiftUI

/// Pill-shaped badge that shifts from green → yellow → red as confidence drops.
/// Thresholds mirror the backend escalation gate: score < 0.6 triggers Opus on pro tier.
struct ConfidenceBadge: View {
    /// Identification confidence from the Claude response. Expected range: 0.0–1.0.
    let score: Double

    private var tint: Color {
        if score >= 0.8 { return Color.Brand.success }
        if score >= 0.5 { return Color.Brand.warning }
        return Color.Brand.error
    }

    var body: some View {
        Text("\(Int(score * 100))% match")
            .font(Typography.caption.weight(.semibold))
            .foregroundStyle(tint)
            .padding(.horizontal, Spacing.sm)
            .padding(.vertical, 3)
            .background(tint.opacity(0.12))
            .clipShape(Capsule())
    }
}

#Preview {
    HStack(spacing: Spacing.sm) {
        ConfidenceBadge(score: 0.92) // green — high confidence
        ConfidenceBadge(score: 0.65) // yellow — medium
        ConfidenceBadge(score: 0.38) // red — low, escalate to Opus
    }
    .padding()
}
