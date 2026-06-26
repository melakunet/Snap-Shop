//
//  Toast.swift
//  Snap&Shop
//
//  Created by ETEFWORKIE MELAKU on 2026-06-26.
//

import SwiftUI

enum ToastVariant {
    case success
    case error

    var icon: String {
        switch self {
        case .success: "checkmark.circle.fill"
        case .error: "xmark.circle.fill"
        }
    }

    var tint: Color {
        switch self {
        case .success: Color.Brand.success
        case .error: Color.Brand.error
        }
    }
}

/// Top-banner notification that auto-dismisses after 2.5 seconds.
/// Place as an overlay on the root container, aligned to `.top`:
///
///     .overlay(alignment: .top) {
///         Toast(message: "Saved!", isPresented: $showToast)
///     }
struct Toast: View {
    let message: String
    var variant: ToastVariant = .success
    @Binding var isPresented: Bool

    var body: some View {
        if isPresented {
            HStack(spacing: Spacing.sm) {
                Image(systemName: variant.icon)
                    .foregroundStyle(variant.tint)
                Text(message)
                    .font(Typography.callout.weight(.medium))
                    .foregroundStyle(Color.Brand.textPrimary)
                Spacer()
            }
            .padding(.horizontal, Spacing.lg)
            .padding(.vertical, Spacing.md)
            .background(Color.Brand.surface)
            .clipShape(RoundedRectangle(cornerRadius: Radius.md))
            .overlay(
                RoundedRectangle(cornerRadius: Radius.md)
                    .strokeBorder(variant.tint.opacity(0.4), lineWidth: 1)
            )
            .shadow(color: .black.opacity(0.12), radius: 8, x: 0, y: 2)
            .padding(.horizontal, Spacing.lg)
            .padding(.top, Spacing.sm)
            .transition(.move(edge: .top).combined(with: .opacity))
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                    withAnimation(.easeOut) {
                        isPresented = false
                    }
                }
            }
        }
    }
}

#Preview("Success") {
    Toast(message: "Saved to history", variant: .success, isPresented: .constant(true))
        .padding(.top, Spacing.xl)
}

#Preview("Error") {
    Toast(
        message: "Failed to load prices — tap to retry",
        variant: .error,
        isPresented: .constant(true)
    )
    .padding(.top, Spacing.xl)
}
