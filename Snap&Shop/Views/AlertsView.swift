//
//  AlertsView.swift
//  Snap&Shop
//
//  Created by ETEFWORKIE MELAKU on 2026-06-26.
//

import SwiftUI

struct AlertsView: View {
    var body: some View {
        NavigationStack {
            VStack(spacing: Spacing.lg) {
                Spacer()
                Image(systemName: "bell.slash")
                    .font(.system(size: 48))
                    .foregroundStyle(Color.Brand.textSecondary)
                Text("No Price Alerts")
                    .font(Typography.headline)
                    .foregroundStyle(Color.Brand.textPrimary)
                Text("Price drop alerts for saved items will appear here.")
                    .font(Typography.body)
                    .foregroundStyle(Color.Brand.textSecondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, Spacing.xl)
                Spacer()
            }
            .navigationTitle("Alerts")
            .navigationBarTitleDisplayMode(.large)
            .background(Color.Brand.background.ignoresSafeArea())
        }
    }
}

#Preview {
    AlertsView()
}
