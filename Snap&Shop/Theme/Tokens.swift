//
//  Tokens.swift
//  Snap&Shop
//
//  Created by Etefworkie Melaku on 2026-05-29.
//

import SwiftUI
import UIKit

// MARK: - Color Tokens

extension Color {
    enum Brand {

        // MARK: Adaptive — light / dark

        static let background = Color(UIColor { traitCollection in
            traitCollection.userInterfaceStyle == .dark
                ? UIColor(red: 14, green: 14, blue: 16)
                : UIColor(red: 250, green: 248, blue: 245)
        })

        static let surface = Color(UIColor { traitCollection in
            traitCollection.userInterfaceStyle == .dark
                ? UIColor(red: 26, green: 26, blue: 29)
                : UIColor(red: 255, green: 255, blue: 255)
        })

        static let surfaceAlt = Color(UIColor { traitCollection in
            traitCollection.userInterfaceStyle == .dark
                ? UIColor(red: 35, green: 35, blue: 39)
                : UIColor(red: 242, green: 238, blue: 231)
        })

        /// contrast vs bg: ≥15:1 (AA ✓)
        static let textPrimary = Color(UIColor { traitCollection in
            traitCollection.userInterfaceStyle == .dark
                ? UIColor(red: 245, green: 242, blue: 236)
                : UIColor(red: 26, green: 26, blue: 26)
        })

        static let textSecondary = Color(UIColor { traitCollection in
            traitCollection.userInterfaceStyle == .dark
                ? UIColor(red: 168, green: 162, blue: 154)
                : UIColor(red: 107, green: 99, blue: 87)
        })

        static let border = Color(UIColor { traitCollection in
            traitCollection.userInterfaceStyle == .dark
                ? UIColor(red: 42, green: 42, blue: 46)
                : UIColor(red: 229, green: 224, blue: 216)
        })

        // MARK: Accent
        // Gold (#C8A86B) on ivory yields ~2.1:1 contrast — fails WCAG AA for body text.

        /// #C8A86B — champagne gold
        static let accent = Color(UIColor(red: 200, green: 168, blue: 107))
        /// #9A7B43 — deeper gold for pressed / active states
        static let accentDeep = Color(UIColor(red: 154, green: 123, blue: 67))
        /// #1A1A1A — text / icon ON a gold surface (contrast ~7.3:1, AA ✓)
        static let accentOn = Color(UIColor(red: 26, green: 26, blue: 26))
        /// #567CAB — muted steel sapphire, used exclusively for Deep Scan mode tint
        static let scanDeep = Color(UIColor(red: 86, green: 124, blue: 168))

        // MARK: Semantic

        static let success = Color(UIColor(red: 79, green: 122, blue: 91))
        static let error = Color(UIColor(red: 179, green: 67, blue: 59))
        static let warning = Color(UIColor(red: 181, green: 138, blue: 46))
    }
}

// MARK: - UIColor convenience (file-private)

private extension UIColor {
    convenience init(red: Int, green: Int, blue: Int, alpha: CGFloat = 1) {
        self.init(
            red: CGFloat(red) / 255,
            green: CGFloat(green) / 255,
            blue: CGFloat(blue) / 255,
            alpha: alpha
        )
    }
}

// MARK: - Typography Tokens

enum Typography {
    static let display: Font = .system(size: 34, weight: .bold, design: .serif)
    static let title: Font = .system(size: 28, weight: .bold, design: .serif)
    static let headline: Font = .system(size: 22, weight: .semibold, design: .serif)
    static let body: Font = .system(size: 17, weight: .regular, design: .default)
    static let callout: Font = .system(size: 15, weight: .regular, design: .default)
    static let caption: Font = .system(size: 13, weight: .regular, design: .default)
}

// MARK: - Spacing Tokens (4-pt base grid)

enum Spacing {
    static let xs: CGFloat = 4
    static let sm: CGFloat = 8
    static let md: CGFloat = 12
    static let lg: CGFloat = 16
    static let xl: CGFloat = 24
    static let xxl: CGFloat = 32
    static let xxxl: CGFloat = 48
}

// MARK: - Radius Tokens

enum Radius {
    static let sm: CGFloat = 8
    static let md: CGFloat = 12
    static let lg: CGFloat = 16
    /// Semantic alias for card surfaces — same value as md, named for intent.
    static let card: CGFloat = 12
    /// Fully-rounded shape; renders as a capsule on any fixed-height view.
    static let pill: CGFloat = 999
}
