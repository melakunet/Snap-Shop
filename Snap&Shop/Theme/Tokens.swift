import SwiftUI
import UIKit

// MARK: - Color Tokens

extension Color {
    enum Brand {

        // MARK: Adaptive — light / dark

        /// #FAF8F5 light · #0E0E10 dark
        static let background = Color(UIColor { tc in
            tc.userInterfaceStyle == .dark
                ? UIColor(r: 14,  g: 14,  b: 16)
                : UIColor(r: 250, g: 248, b: 245)
        })

        /// #FFFFFF light · #1A1A1D dark
        static let surface = Color(UIColor { tc in
            tc.userInterfaceStyle == .dark
                ? UIColor(r: 26,  g: 26,  b: 29)
                : UIColor(r: 255, g: 255, b: 255)
        })

        /// #F2EEE7 light · #232327 dark
        static let surfaceAlt = Color(UIColor { tc in
            tc.userInterfaceStyle == .dark
                ? UIColor(r: 35,  g: 35,  b: 39)
                : UIColor(r: 242, g: 238, b: 231)
        })

        /// #1A1A1A light · #F5F2EC dark  — contrast vs bg: ≥15:1 (AA ✓)
        static let textPrimary = Color(UIColor { tc in
            tc.userInterfaceStyle == .dark
                ? UIColor(r: 245, g: 242, b: 236)
                : UIColor(r: 26,  g: 26,  b: 26)
        })

        /// #6B6357 light · #A8A29A dark
        static let textSecondary = Color(UIColor { tc in
            tc.userInterfaceStyle == .dark
                ? UIColor(r: 168, g: 162, b: 154)
                : UIColor(r: 107, g: 99,  b: 87)
        })

        /// #E5E0D8 light · #2A2A2E dark
        static let border = Color(UIColor { tc in
            tc.userInterfaceStyle == .dark
                ? UIColor(r: 42,  g: 42,  b: 46)
                : UIColor(r: 229, g: 224, b: 216)
        })

        // MARK: Accent — champagne gold (mode-independent)
        //
        // Use ONLY for icons, decorative elements, and display-scale headings in dark mode.
        // Gold (#C8A86B) on ivory background yields ~2.1:1 contrast — fails WCAG AA for
        // all text sizes. Never apply accent as a body-text colour.

        /// #C8A86B — champagne gold
        static let accent     = Color(UIColor(r: 200, g: 168, b: 107))
        /// #9A7B43 — deeper gold for pressed / active states
        static let accentDeep = Color(UIColor(r: 154, g: 123, b: 67))
        /// #1A1A1A — text / icon placed ON a gold surface (contrast vs accent ~7.3:1, AA ✓)
        static let accentOn   = Color(UIColor(r: 26,  g: 26,  b: 26))
        /// #567CAB — muted steel sapphire, used exclusively for Deep Scan mode tint
        static let scanDeep   = Color(UIColor(r: 86,  g: 124, b: 168))

        // MARK: Semantic

        static let success = Color(UIColor(r: 79,  g: 122, b: 91))
        static let error   = Color(UIColor(r: 179, g: 67,  b: 59))
        static let warning = Color(UIColor(r: 181, g: 138, b: 46))
    }
}

// MARK: - UIColor convenience (file-private)

private extension UIColor {
    convenience init(r: Int, g: Int, b: Int, a: CGFloat = 1) {
        self.init(
            red:   CGFloat(r) / 255,
            green: CGFloat(g) / 255,
            blue:  CGFloat(b) / 255,
            alpha: a
        )
    }
}

// MARK: - Typography Tokens

enum Typography {
    // Display and headings → New York serif (.serif design).
    // Body and UI copy   → SF Pro sans-serif (.default design).

    static let display:  Font = .system(size: 34, weight: .bold,     design: .serif)
    static let title:    Font = .system(size: 28, weight: .bold,     design: .serif)
    static let headline: Font = .system(size: 22, weight: .semibold, design: .serif)
    static let body:     Font = .system(size: 17, weight: .regular,  design: .default)
    static let callout:  Font = .system(size: 15, weight: .regular,  design: .default)
    static let caption:  Font = .system(size: 13, weight: .regular,  design: .default)
}

// MARK: - Spacing Tokens (4-pt base grid)

enum Spacing {
    static let xs:   CGFloat = 4
    static let sm:   CGFloat = 8
    static let md:   CGFloat = 12
    static let lg:   CGFloat = 16
    static let xl:   CGFloat = 24
    static let xxl:  CGFloat = 32
    static let xxxl: CGFloat = 48
}

// MARK: - Radius Tokens

enum Radius {
    static let sm: CGFloat = 8
    static let md: CGFloat = 12
    static let lg: CGFloat = 16
}
