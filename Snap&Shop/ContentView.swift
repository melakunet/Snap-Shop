import SwiftUI

struct ContentView: View {
    @State private var showOnboarding = true
    @State private var showPaywall = false
    @State private var selectedTab: Tab = .camera

    var body: some View {
        Group {
            if showOnboarding {
                OnboardingView {
                    withAnimation(.easeInOut) { showOnboarding = false }
                }
            } else {
                mainTabs
            }
        }
        .sheet(isPresented: $showPaywall) {
            PaywallView()
        }
    }

    private var mainTabs: some View {
        TabView(selection: $selectedTab) {
            CameraView()
                .tabItem {
                    Label("Scan", systemImage: "camera.viewfinder")
                }
                .tag(Tab.camera)

            ResultsView()
                .tabItem {
                    Label("Results", systemImage: "list.bullet.below.rectangle")
                }
                .tag(Tab.results)

            HistoryView()
                .tabItem {
                    Label("History", systemImage: "clock.arrow.circlepath")
                }
                .tag(Tab.history)

            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gearshape")
                }
                .tag(Tab.settings)
        }
        .tint(Color.Brand.accent)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    showPaywall = true
                } label: {
                    Label("Pro", systemImage: "sparkles")
                        .font(Typography.callout.weight(.semibold))
                        .foregroundStyle(Color.Brand.accent)
                }
            }
        }
    }
}

private enum Tab {
    case camera, results, history, settings
}

#Preview {
    ContentView()
}
