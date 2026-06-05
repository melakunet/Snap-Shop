import SwiftUI

struct PaywallView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var selectedPlan: Plan = .annual
    @State private var isPurchasing = false

    var body: some View {
        ZStack(alignment: .topTrailing) {
            Color.Brand.background.ignoresSafeArea()

            ScrollView {
                VStack(spacing: Spacing.xxl) {
                    header
                    featureList
                    planPicker
                    ctaButton
                    footer
                }
                .padding(.horizontal, Spacing.xl)
                .padding(.top, Spacing.xxxl)
                .padding(.bottom, Spacing.xxl)
            }

            Button { dismiss() } label: {
                Image(systemName: "xmark")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(Color.Brand.textSecondary)
                    .frame(width: 30, height: 30)
                    .background(Color.Brand.surfaceAlt)
                    .clipShape(Circle())
            }
            .padding([.top, .trailing], Spacing.xl)
        }
    }

    // MARK: — Header

    private var header: some View {
        VStack(spacing: Spacing.md) {
            ZStack {
                Circle()
                    .fill(
                        RadialGradient(
                            colors: [Color.Brand.accent.opacity(0.2), .clear],
                            center: .center,
                            startRadius: 0,
                            endRadius: 80
                        )
                    )
                    .frame(width: 160, height: 160)
                Image(systemName: "sparkles")
                    .font(.system(size: 46))
                    .foregroundStyle(Color.Brand.accent)
            }
            Text("Snap & Shop Pro")
                .font(Typography.display)
                .foregroundStyle(Color.Brand.textPrimary)
                .multilineTextAlignment(.center)
            Text("Unlimited scans. Live prices.\nAlways the best deal.")
                .font(Typography.body)
                .foregroundStyle(Color.Brand.textSecondary)
                .multilineTextAlignment(.center)
        }
    }

    // MARK: — Features

    private var featureList: some View {
        VStack(spacing: Spacing.sm) {
            ForEach(Feature.all) { feature in
                HStack(spacing: Spacing.md) {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundStyle(Color.Brand.accent)
                        .font(.system(size: 20))
                    VStack(alignment: .leading, spacing: 2) {
                        Text(feature.title)
                            .font(Typography.callout.weight(.semibold))
                            .foregroundStyle(Color.Brand.textPrimary)
                        Text(feature.subtitle)
                            .font(Typography.caption)
                            .foregroundStyle(Color.Brand.textSecondary)
                    }
                    Spacer()
                }
                .padding(Spacing.md)
                .background(Color.Brand.surface)
                .clipShape(RoundedRectangle(cornerRadius: Radius.md))
            }
        }
    }

    // MARK: — Plan picker

    private var planPicker: some View {
        VStack(spacing: Spacing.sm) {
            ForEach(Plan.allCases) { planCard($0) }
        }
    }

    private func planCard(_ plan: Plan) -> some View {
        let selected = selectedPlan == plan
        return Button {
            withAnimation(.spring(duration: 0.2)) { selectedPlan = plan }
        } label: {
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    HStack(spacing: Spacing.sm) {
                        Text(plan.title)
                            .font(Typography.callout.weight(.semibold))
                            .foregroundStyle(Color.Brand.textPrimary)
                        if plan == .annual {
                            Text("BEST VALUE")
                                .font(.system(size: 10, weight: .bold))
                                .foregroundStyle(Color.Brand.accentOn)
                                .padding(.horizontal, Spacing.sm)
                                .padding(.vertical, 2)
                                .background(Color.Brand.accent)
                                .clipShape(Capsule())
                        }
                    }
                    Text(plan.priceDescription)
                        .font(Typography.caption)
                        .foregroundStyle(Color.Brand.textSecondary)
                }
                Spacer()
                Text(plan.price)
                    .font(Typography.headline)
                    .foregroundStyle(selected ? Color.Brand.accent : Color.Brand.textPrimary)
                Image(systemName: selected ? "checkmark.circle.fill" : "circle")
                    .foregroundStyle(selected ? Color.Brand.accent : Color.Brand.border)
                    .font(.system(size: 22))
            }
            .padding(Spacing.lg)
            .background(Color.Brand.surface)
            .clipShape(RoundedRectangle(cornerRadius: Radius.md))
            .overlay(
                RoundedRectangle(cornerRadius: Radius.md)
                    .strokeBorder(
                        selected ? Color.Brand.accent : Color.Brand.border,
                        lineWidth: selected ? 2 : 1
                    )
            )
        }
        .buttonStyle(.plain)
    }

    // MARK: — CTA

    private var ctaButton: some View {
        Button {
            guard !isPurchasing else { return }
            isPurchasing = true
            Task {
                try? await Task.sleep(nanoseconds: 2_000_000_000)
                await MainActor.run { isPurchasing = false }
            }
        } label: {
            ZStack {
                Text("Start Free Trial")
                    .opacity(isPurchasing ? 0 : 1)
                if isPurchasing {
                    ProgressView()
                        .tint(Color.Brand.accentOn)
                }
            }
            .font(Typography.callout.weight(.semibold))
            .foregroundStyle(Color.Brand.accentOn)
            .frame(maxWidth: .infinity)
            .frame(height: 52)
            .background(Color.Brand.accent.opacity(isPurchasing ? 0.7 : 1.0))
            .clipShape(RoundedRectangle(cornerRadius: Radius.md))
        }
        .disabled(isPurchasing)
        .animation(.easeInOut(duration: 0.15), value: isPurchasing)
    }

    // MARK: — Footer

    private var footer: some View {
        VStack(spacing: Spacing.sm) {
            Button("Restore Purchases") {}
                .font(Typography.caption)
                .foregroundStyle(Color.Brand.textSecondary)
            Text("Cancel anytime. Billed via App Store.\nNo charge until trial ends.")
                .font(Typography.caption)
                .foregroundStyle(Color.Brand.textSecondary)
                .multilineTextAlignment(.center)
        }
    }
}

// MARK: — Supporting types

private enum Plan: String, CaseIterable, Identifiable {
    case annual, monthly
    var id: String { rawValue }

    var title: String {
        switch self {
        case .annual: "Annual"
        case .monthly: "Monthly"
        }
    }

    var price: String {
        switch self {
        case .annual: "$39.99"
        case .monthly: "$4.99"
        }
    }

    var priceDescription: String {
        switch self {
        case .annual: "$3.33 / month — save 33%"
        case .monthly: "Billed monthly"
        }
    }
}

private struct Feature: Identifiable {
    let id = UUID()
    let title: String
    let subtitle: String

    static let all: [Feature] = [
        Feature(title: "Unlimited Scans", subtitle: "Scan as many products as you like"),
        Feature(title: "Deep / Video Scan", subtitle: "Multi-image burst & video pan support"),
        Feature(title: "Live Price Tracking", subtitle: "Real-time results from 6+ retailers"),
        Feature(title: "Price Drop Alerts", subtitle: "Get notified when a saved item drops"),
        Feature(title: "iCloud Sync", subtitle: "History & favourites across all your devices")
    ]
}

#Preview {
    PaywallView()
}
