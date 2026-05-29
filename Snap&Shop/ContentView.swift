import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack(spacing: 8) {
            Text("Welcome to")
                .font(.subheadline)
                .foregroundStyle(.secondary)

            Text("Snap & Shop")
                .font(.largeTitle)
                .fontWeight(.bold)

            Text("Snap any product. See the best price.")
                .font(.callout)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#Preview {
    ContentView()
}
