//
//  SavedView.swift
//  Snap&Shop
//
//  Created by ETEFWORKIE MELAKU on 2026-06-26.
//

import SwiftUI

struct SavedView: View {
    var body: some View {
        NavigationStack {
            VStack(spacing: Spacing.lg) {
                Spacer()
                Image(systemName: "heart.slash")
                    .font(.system(size: 48))
                    .foregroundStyle(Color.Brand.textSecondary)
                Text("No Saved Items")
                    .font(Typography.headline)
                    .foregroundStyle(Color.Brand.textPrimary)
                Text("Items you save from scan results will appear here.")
                    .font(Typography.body)
                    .foregroundStyle(Color.Brand.textSecondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, Spacing.xl)
                Spacer()
            }
            .navigationTitle("Saved")
            .navigationBarTitleDisplayMode(.large)
            .background(Color.Brand.background.ignoresSafeArea())
        }
    }
}

#Preview {
    SavedView()
}
