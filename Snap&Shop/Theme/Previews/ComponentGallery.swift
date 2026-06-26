//
//  ComponentGallery.swift
//  Snap&Shop
//
//  Created by ETEFWORKIE MELAKU on 2026-06-26.
//

#if DEBUG
    import SwiftUI

    /// Developer screen reachable from Settings → Developer → Design system (debug builds only).
    /// Each row renders the component twice: left pane forced to light mode, right to dark.
    struct ComponentGallery: View {
        var body: some View {
            ScrollView {
                LazyVStack(alignment: .leading, spacing: Spacing.xl) {
                    gallerySection("PrimaryButton") { primaryButtonRows }
                    gallerySection("Card") { cardRow }
                    gallerySection("EmptyState") { emptyStateRow }
                    gallerySection("Toast") { toastRows }
                    gallerySection("ConfidenceBadge") { confidenceBadgeRow }
                    gallerySection("ModeBadge") { modeBadgeRow }
                }
                .padding(Spacing.lg)
            }
            .navigationTitle("Design system")
            .navigationBarTitleDisplayMode(.large)
            .background(Color.Brand.background.ignoresSafeArea())
        }

        // MARK: — Sections

        private var primaryButtonRows: some View {
            VStack(spacing: Spacing.sm) {
                dualPane { PrimaryButton(title: "Find prices") {} }
                dualPane { PrimaryButton(title: "Loading…", isLoading: true) {} }
                dualPane { PrimaryButton(title: "Find prices", isDisabled: true) {} }
            }
        }

        private var cardRow: some View {
            dualPane {
                Card {
                    VStack(alignment: .leading, spacing: Spacing.xs) {
                        Text("Sony WH-1000XM5")
                            .font(Typography.callout.weight(.semibold))
                            .foregroundStyle(Color.Brand.textPrimary)
                        Text("Over-ear headphones")
                            .font(Typography.caption)
                            .foregroundStyle(Color.Brand.textSecondary)
                    }
                    .padding(Spacing.md)
                }
            }
        }

        private var emptyStateRow: some View {
            dualPane {
                EmptyState(
                    icon: "heart.slash",
                    title: "Nothing saved",
                    subtitle: "Items you bookmark will appear here."
                )
                .frame(height: 200)
            }
        }

        private var toastRows: some View {
            VStack(spacing: Spacing.sm) {
                dualPane {
                    Toast(message: "Saved to history", variant: .success, isPresented: .constant(true))
                }
                dualPane {
                    Toast(message: "Failed to load prices", variant: .error, isPresented: .constant(true))
                }
            }
        }

        private var confidenceBadgeRow: some View {
            dualPane {
                HStack(spacing: Spacing.sm) {
                    ConfidenceBadge(score: 0.92)
                    ConfidenceBadge(score: 0.65)
                    ConfidenceBadge(score: 0.38)
                }
                .padding(Spacing.xs)
            }
        }

        private var modeBadgeRow: some View {
            dualPane {
                HStack(spacing: Spacing.lg) {
                    ModeBadge(mode: .precision)
                    ModeBadge(mode: .deep)
                }
                .padding(Spacing.xs)
            }
        }

        // MARK: — Helpers

        private func gallerySection(
            _ title: String,
            @ViewBuilder content: () -> some View
        ) -> some View {
            VStack(alignment: .leading, spacing: Spacing.sm) {
                Text(title)
                    .font(Typography.caption.weight(.semibold))
                    .foregroundStyle(Color.Brand.textSecondary)
                content()
            }
        }

        /// Renders `content` twice side-by-side: left pane in light mode, right in dark.
        private func dualPane(@ViewBuilder _ content: () -> some View) -> some View {
            HStack(spacing: 1) {
                content()
                    .frame(maxWidth: .infinity)
                    .padding(Spacing.sm)
                    .background(Color(.systemBackground))
                    .environment(\.colorScheme, .light)

                content()
                    .frame(maxWidth: .infinity)
                    .padding(Spacing.sm)
                    .background(Color(.systemBackground))
                    .environment(\.colorScheme, .dark)
            }
            .clipShape(RoundedRectangle(cornerRadius: Radius.md))
            .overlay(
                RoundedRectangle(cornerRadius: Radius.md)
                    .strokeBorder(Color.Brand.border, lineWidth: 1)
            )
        }
    }

    #Preview {
        NavigationStack {
            ComponentGallery()
        }
    }
#endif
