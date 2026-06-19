import SwiftUI

struct HistoryItem: Identifiable {
    let id = UUID()
    let productName: String
    let scanMode: ScanMode
    let date: Date
    let lowestPrice: Double
    let retailer: String
}

enum HistoryPhase {
    case loading
    case loaded([HistoryItem])
    case error(String)
}

struct HistoryView: View {
    @State private var phase: HistoryPhase
    @State private var searchText = ""

    init(phase: HistoryPhase = .loaded(HistoryItem.samples)) {
        _phase = State(initialValue: phase)
    }

    private var items: [HistoryItem] {
        guard case .loaded(let list) = phase else { return [] }
        return list
    }

    private var searchFiltered: [HistoryItem] {
        guard !searchText.isEmpty else { return items }
        return items.filter { $0.productName.localizedCaseInsensitiveContains(searchText) }
    }

    var body: some View {
        NavigationStack {
            Group {
                switch phase {
                case .loading:
                    loadingView
                case .loaded(let list) where list.isEmpty:
                    emptyView
                case .loaded:
                    listView
                case .error(let msg):
                    errorView(msg)
                }
            }
            .navigationTitle("History")
            .navigationBarTitleDisplayMode(.large)
            .toolbar { clearButton }
            .background(Color.Brand.background.ignoresSafeArea())
        }
    }

    // MARK: — List

    private var listView: some View {
        List {
            ForEach(searchFiltered) { item in
                historyRow(item)
                    .listRowBackground(Color.Brand.surface)
                    .listRowSeparatorTint(Color.Brand.border)
            }
            .onDelete { offsets in
                if case .loaded(var list) = phase {
                    list.remove(atOffsets: offsets)
                    withAnimation { phase = .loaded(list) }
                }
            }
        }
        .listStyle(.insetGrouped)
        .scrollContentBackground(.hidden)
        .searchable(text: $searchText, prompt: "Search products")
    }

    private func historyRow(_ item: HistoryItem) -> some View {
        HStack(spacing: Spacing.md) {
            ZStack {
                RoundedRectangle(cornerRadius: Radius.sm)
                    .fill(Color.Brand.surfaceAlt)
                    .frame(width: 52, height: 52)
                Image(systemName: "photo")
                    .foregroundStyle(Color.Brand.textSecondary)
            }

            VStack(alignment: .leading, spacing: Spacing.xs) {
                Text(item.productName)
                    .font(Typography.callout.weight(.semibold))
                    .foregroundStyle(Color.Brand.textPrimary)
                    .lineLimit(1)
                HStack(spacing: Spacing.xs) {
                    modeBadge(item.scanMode)
                    Text(item.date, style: .date)
                        .font(Typography.caption)
                        .foregroundStyle(Color.Brand.textSecondary)
                }
            }

            Spacer()

            VStack(alignment: .trailing, spacing: Spacing.xs) {
                Text("$\(item.lowestPrice, specifier: "%.2f")")
                    .font(Typography.callout.weight(.semibold))
                    .foregroundStyle(Color.Brand.accent)
                Text(item.retailer)
                    .font(Typography.caption)
                    .foregroundStyle(Color.Brand.textSecondary)
            }
        }
        .padding(.vertical, Spacing.xs)
    }

    private func modeBadge(_ mode: ScanMode) -> some View {
        let badgeColor = mode == .precision ? Color.Brand.accent : Color.Brand.scanDeep
        return HStack(spacing: 3) {
            Image(systemName: mode == .precision ? "camera.aperture" : "video.fill")
                .font(.system(size: 9, weight: .semibold))
            Text(mode == .precision ? "Precision" : "Deep")
                .font(Typography.caption.weight(.medium))
        }
        .foregroundStyle(mode == .precision ? Color.Brand.accentOn : .white)
        .padding(.horizontal, Spacing.sm)
        .padding(.vertical, 2)
        .background(badgeColor)
        .clipShape(Capsule())
    }

    // MARK: — Loading skeleton

    private var loadingView: some View {
        List {
            ForEach(0..<5, id: \.self) { _ in
                HStack(spacing: Spacing.md) {
                    ShimmerRect(height: 52).frame(width: 52)
                    VStack(alignment: .leading, spacing: Spacing.sm) {
                        ShimmerRect(height: 15).frame(width: 160)
                        ShimmerRect(height: 12).frame(width: 100)
                    }
                    Spacer()
                    VStack(alignment: .trailing, spacing: Spacing.sm) {
                        ShimmerRect(height: 15).frame(width: 60)
                        ShimmerRect(height: 12).frame(width: 48)
                    }
                }
                .padding(.vertical, Spacing.xs)
                .listRowBackground(Color.Brand.surface)
                .listRowSeparatorTint(Color.Brand.border)
            }
        }
        .listStyle(.insetGrouped)
        .scrollContentBackground(.hidden)
        .allowsHitTesting(false)
    }

    // MARK: — Empty

    private var emptyView: some View {
        VStack(spacing: Spacing.xl) {
            Image(systemName: "clock.arrow.circlepath")
                .font(.system(size: 52))
                .foregroundStyle(Color.Brand.textSecondary)
            VStack(spacing: Spacing.sm) {
                Text("No scans yet")
                    .font(Typography.headline)
                    .foregroundStyle(Color.Brand.textPrimary)
                Text("Your scan history will appear here.")
                    .font(Typography.body)
                    .foregroundStyle(Color.Brand.textSecondary)
                    .multilineTextAlignment(.center)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(Spacing.xxl)
    }

    // MARK: — Error

    private func errorView(_ message: String) -> some View {
        VStack(spacing: Spacing.xl) {
            Image(systemName: "exclamationmark.triangle")
                .font(.system(size: 52))
                .foregroundStyle(Color.Brand.error)
            VStack(spacing: Spacing.sm) {
                Text("Couldn't load history")
                    .font(Typography.headline)
                    .foregroundStyle(Color.Brand.textPrimary)
                Text(message)
                    .font(Typography.body)
                    .foregroundStyle(Color.Brand.textSecondary)
                    .multilineTextAlignment(.center)
            }
            Button("Retry") { phase = .loading }
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

    private var clearButton: some ToolbarContent {
        ToolbarItem(placement: .topBarTrailing) {
            Button(role: .destructive) {
                withAnimation { phase = .loaded([]) }
            } label: {
                Text("Clear")
                    .font(Typography.callout)
                    .foregroundStyle(Color.Brand.error)
            }
            .disabled(items.isEmpty)
        }
    }
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

extension HistoryItem {
    static let samples: [HistoryItem] = [
        HistoryItem(
            productName: "Sony WH-1000XM5 Headphones",
            scanMode: .precision,
            date: .now,
            lowestPrice: 279.99,
            retailer: "Amazon"
        ),
        HistoryItem(
            productName: "Apple AirPods Pro 2",
            scanMode: .deep,
            date: Calendar.current.date(byAdding: .day, value: -1, to: .now)!,
            lowestPrice: 189.00,
            retailer: "Walmart"
        ),
        HistoryItem(
            productName: "Samsung 65\" QLED TV",
            scanMode: .deep,
            date: Calendar.current.date(byAdding: .day, value: -3, to: .now)!,
            lowestPrice: 899.00,
            retailer: "Best Buy"
        )
    ]
}

#Preview("Loaded") { HistoryView() }
#Preview("Loading") { HistoryView(phase: .loading) }
#Preview("Empty") { HistoryView(phase: .loaded([])) }
#Preview("Error") { HistoryView(phase: .error("Could not connect to iCloud.")) }
