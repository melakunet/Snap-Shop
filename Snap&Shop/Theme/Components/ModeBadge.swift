//
//  ModeBadge.swift
//  Snap&Shop
//
//  Created by ETEFWORKIE MELAKU on 2026-06-26.
//

import SwiftUI

/// Inline mode indicator: icon + label, tinted by scan mode.
/// Shape is identical to the private `modeBadge` in ResultsView — that
/// property can be swapped for this component in a later refactor.
struct ModeBadge: View {
    let mode: ScanMode

    private var icon: String {
        mode == .precision ? "camera.aperture" : "video.fill"
    }

    private var label: String {
        mode == .precision ? "Precision Scan" : "Deep Scan"
    }

    private var tint: Color {
        mode == .precision ? Color.Brand.accent : Color.Brand.scanDeep
    }

    var body: some View {
        HStack(spacing: Spacing.xs) {
            Image(systemName: icon)
                .font(.system(size: 10, weight: .semibold))
            Text(label)
                .font(Typography.caption.weight(.semibold))
        }
        .foregroundStyle(tint)
    }
}

#Preview {
    HStack(spacing: Spacing.lg) {
        ModeBadge(mode: .precision)
        ModeBadge(mode: .deep)
    }
    .padding()
}
