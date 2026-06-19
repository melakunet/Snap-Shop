import SwiftUI

struct PriceResult: Identifiable {
    let id = UUID()
    let retailer: String
    let price: String
    let shipping: String
    let rating: String
    let isBest: Bool
}

enum ResultsPhase {
    case loading
    case loaded([PriceResult])
    case empty
    case error(String)
}

struct ResultsView: View {
    var scanMode: ScanMode
    @State private var phase: ResultsPhase
    @State private var isSaved = false

    init(scanMode: ScanMode = .precision, phase: ResultsPhase = .loaded(PriceResult.samples)) {
        self.scanMode = scanMode
        _phase = State(initialValue: phase)
    }

    var body: some View {
        NavigationStack {
            ZStack {
                Color.Brand.background.ignoresSafeArea()
                content
            }
            .navigationTitle("Results")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Image("AppLogo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 28, height: 28)
                        .clipShape(RoundedRectangle(cornerRadius: 6))
                }
                saveButton
            }
        }
    }

    @ViewBuilder
    private var content: some View {
        switch phase {
        case .loading:
            loadingView
        case .loaded(let results):
            loadedView(results)
        case .empty:
            emptyView
        case .error(let msg):
            errorView(msg)
        }
    }

    // MARK: — Loaded

    private func loadedView(_ results: [PriceResult]) -> some View {
        ScrollView {
            VStack(alignment: .leading, spacing: Spacing.xl) {
                productHeader
                    .padding(.horizontal, Spacing.xl)
                VStack(spacing: Spacing.sm) {
                    ForEach(results) { priceRow($0) }
                }
                .padding(.horizontal, Spacing.xl)
            }
            .padding(.top, Spacing.xl)
            .padding(.bottom, Spacing.xxxl)
        }
    }

    private var productHeader: some View {
        HStack(spacing: Spacing.lg) {
            Image("product_headphones")
                .resizable()
                .scaledToFill()
                .frame(width: 80, height: 80)
                .clipShape(RoundedRectangle(cornerRadius: Radius.md))
            VStack(alignment: .leading, spacing: Spacing.xs) {
                Text("Sony WH-1000XM5 Headphones")
                    .font(Typography.headline)
                    .foregroundStyle(Color.Brand.textPrimary)
                modeBadge
            }
        }
    }

    private var modeBadge: some View {
        HStack(spacing: Spacing.xs) {
            Image(systemName: scanMode == .precision ? "camera.aperture" : "video.fill")
                .font(.system(size: 10, weight: .semibold))
            Text(scanMode == .precision ? "Precision Scan" : "Deep Scan")
                .font(Typography.caption.weight(.semibold))
        }
        .foregroundStyle(scanMode == .precision ? Color.Brand.accent : Color.Brand.scanDeep)
    }

    private func priceRow(_ result: PriceResult) -> some View {
        HStack {
            VStack(alignment: .leading, spacing: Spacing.xs) {
                HStack(spacing: Spacing.sm) {
                    Text(result.retailer)
                        .font(Typography.callout.weight(.semibold))
                        .foregroundStyle(Color.Brand.textPrimary)
                    if result.isBest { bestBadge }
                }
                Text("\(result.shipping) shipping · \(result.rating)")
                    .font(Typography.caption)
                    .foregroundStyle(Color.Brand.textSecondary)
            }
            Spacer()
            VStack(alignment: .trailing, spacing: Spacing.xs) {
                Text(result.price)
                    .font(Typography.callout.weight(.bold))
                    .foregroundStyle(result.isBest ? Color.Brand.success : Color.Brand.textPrimary)
                Button("View") {}
                    .font(Typography.caption.weight(.semibold))
                    .foregroundStyle(Color.Brand.accent)
            }
        }
        .padding(Spacing.lg)
        .background(Color.Brand.surface)
        .clipShape(RoundedRectangle(cornerRadius: Radius.md))
        .overlay(
            RoundedRectangle(cornerRadius: Radius.md)
                .strokeBorder(
                    result.isBest ? Color.Brand.success.opacity(0.5) : Color.Brand.border,
                    lineWidth: result.isBest ? 1.5 : 1
                )
        )
    }

    private var bestBadge: some View {
        HStack(spacing: 3) {
            Image(systemName: "checkmark")
                .font(.system(size: 9, weight: .bold))
            Text("Best Price")
                .font(Typography.caption.weight(.semibold))
        }
        .foregroundStyle(Color.white)
        .padding(.horizontal, Spacing.sm)
        .padding(.vertical, 2)
        .background(Color.Brand.success)
        .clipShape(Capsule())
    }

    // MARK: — Loading skeleton

    private var loadingView: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: Spacing.xl) {
                HStack(spacing: Spacing.lg) {
                    ShimmerRect(height: 80).frame(width: 80)
                    VStack(alignment: .leading, spacing: Spacing.sm) {
                        ShimmerRect(height: 18).frame(width: 180)
                        ShimmerRect(height: 14).frame(width: 90)
                    }
                    Spacer()
                }
                .padding(.horizontal, Spacing.xl)

                VStack(spacing: Spacing.sm) {
                    ForEach(0..<4, id: \.self) { _ in skeletonRow }
                }
                .padding(.horizontal, Spacing.xl)
            }
            .padding(.top, Spacing.xl)
        }
    }

    private var skeletonRow: some View {
        HStack {
            VStack(alignment: .leading, spacing: Spacing.sm) {
                ShimmerRect(height: 16).frame(width: 100)
                ShimmerRect(height: 13).frame(width: 150)
            }
            Spacer()
            ShimmerRect(height: 20).frame(width: 64)
        }
        .padding(Spacing.lg)
        .background(Color.Brand.surface)
        .clipShape(RoundedRectangle(cornerRadius: Radius.md))
    }

    // MARK: — Empty

    private var emptyView: some View {
        centeredState(
            CenteredStateConfig(
                icon: "magnifyingglass",
                iconColor: Color.Brand.textSecondary,
                title: "No results found",
                body: "We couldn't match this product.\nTry Deep Scan for a better result.",
                actionLabel: "Try Deep Scan"
            )
        ) { phase = .loading }
    }

    // MARK: — Error

    private func errorView(_ message: String) -> some View {
        centeredState(
            CenteredStateConfig(
                icon: "wifi.exclamationmark",
                iconColor: Color.Brand.error,
                title: "Couldn't load prices",
                body: message,
                actionLabel: "Try Again"
            )
        ) { phase = .loading }
    }

    // MARK: — Shared centred layout

    private func centeredState(_ config: CenteredStateConfig, action: @escaping () -> Void) -> some View {
        VStack(spacing: Spacing.xl) {
            Image(systemName: config.icon)
                .font(.system(size: 52))
                .foregroundStyle(config.iconColor)
            VStack(spacing: Spacing.sm) {
                Text(config.title)
                    .font(Typography.headline)
                    .foregroundStyle(Color.Brand.textPrimary)
                Text(config.body)
                    .font(Typography.body)
                    .foregroundStyle(Color.Brand.textSecondary)
                    .multilineTextAlignment(.center)
            }
            Button(config.actionLabel, action: action)
                .font(Typography.callout.weight(.semibold))
                .foregroundStyle(Color.Brand.accentOn)
                .padding(.horizontal, Spacing.xxl)
                .padding(.vertical, Spacing.md)
                .background(Color.Brand.accent)
                .clipShape(RoundedRectangle(cornerRadius: Radius.md))
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(Spacing.xxl)
    }

    // MARK: — Toolbar

    private var saveButton: some ToolbarContent {
        ToolbarItem(placement: .topBarTrailing) {
            Button {
                withAnimation(.spring(duration: 0.25)) { isSaved.toggle() }
            } label: {
                Image(systemName: isSaved ? "bookmark.fill" : "bookmark")
                    .foregroundStyle(Color.Brand.accent)
                    .symbolEffect(.bounce, value: isSaved)
            }
        }
    }
}

// MARK: — Config type (replaces 6-param centeredState)

private struct CenteredStateConfig {
    let icon: String
    let iconColor: Color
    let title: String
    let body: String
    let actionLabel: String
}

// MARK: — Shimmer helper

private struct ShimmerRect: View {
    @State private var isShimmering = false
    var height: CGFloat

    var body: some View {
        RoundedRectangle(cornerRadius: Radius.sm)
            .fill(Color.Brand.surfaceAlt)
            .frame(height: height)
            .opacity(isShimmering ? 0.4 : 0.9)
            .onAppear {
                withAnimation(.easeInOut(duration: 0.85).repeatForever(autoreverses: true)) {
                    isShimmering = true
                }
            }
    }
}

// MARK: — Sample data

extension PriceResult {
    static let samples: [PriceResult] = [
        PriceResult(retailer: "Amazon", price: "$279.99", shipping: "Free", rating: "4.8★", isBest: true),
        PriceResult(retailer: "Walmart", price: "$289.95", shipping: "$5.99", rating: "4.6★", isBest: false),
        PriceResult(retailer: "Best Buy", price: "$299.99", shipping: "Free", rating: "4.7★", isBest: false),
        PriceResult(retailer: "eBay", price: "$259.00", shipping: "$12.00", rating: "4.4★", isBest: false),
        PriceResult(retailer: "Target", price: "$319.99", shipping: "Free", rating: "4.5★", isBest: false)
    ]
}

#Preview("Loaded — Precision") { ResultsView() }
#Preview("Loaded — Deep") { ResultsView(scanMode: .deep) }
#Preview("Loading") { ResultsView(phase: .loading) }
#Preview("Empty") { ResultsView(phase: .empty) }
#Preview("Error") { ResultsView(phase: .error("Network connection lost. Check your Wi-Fi.")) }
