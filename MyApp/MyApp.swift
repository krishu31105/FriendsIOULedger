
import SwiftUI

@main
struct MyApp: App {

    var body: some Scene {
        WindowGroup {
            RootView()
        }
    }
}

// MARK: - Root View

struct RootView: View {

    @State private var showSplash = true

    var body: some View {

        ZStack {

            if showSplash {
                SplashScreenView()
                    .transition(.opacity)
            } else {
                ContentView()
                    .transition(.opacity)
            }
        }
        .task {
            try? await Task.sleep(nanoseconds: 2_500_000_000)

            withAnimation(.easeInOut(duration: 0.6)) {
                showSplash = false
            }
        }
    }
}

// MARK: - Splash Screen

struct SplashScreenView: View {

    @State private var animateLogo = false

    private let purple = Color(
        red: 0.55,
        green: 0.35,
        blue: 0.95
    )

    private let lightPurple = Color(
        red: 0.75,
        green: 0.60,
        blue: 1.0
    )

    var body: some View {

        ZStack {

            LinearGradient(
                colors: [
                    Color(red: 0.06, green: 0.04, blue: 0.13),
                    Color(red: 0.14, green: 0.08, blue: 0.28),
                    Color(red: 0.05, green: 0.05, blue: 0.12)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            Circle()
                .fill(purple.opacity(0.25))
                .frame(width: 250, height: 250)
                .blur(radius: 90)
                .offset(x: -100, y: -180)

            Circle()
                .fill(lightPurple.opacity(0.2))
                .frame(width: 220, height: 220)
                .blur(radius: 90)
                .offset(x: 120, y: 180)

            VStack(spacing: 22) {

                // App Logo

                ZStack {

                    RoundedRectangle(cornerRadius: 30)
                        .fill(
                            LinearGradient(
                                colors: [purple, lightPurple],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 115, height: 115)
                        .shadow(
                            color: purple.opacity(0.5),
                            radius: 25
                        )

                    Image(systemName: "wallet.pass.fill")
                        .font(.system(size: 52))
                        .foregroundColor(.white)
                }
                .scaleEffect(animateLogo ? 1.0 : 0.7)
                .opacity(animateLogo ? 1.0 : 0.0)

                // App Name

                VStack(spacing: 10) {

                    Text("Friends IOU Ledger")
                        .font(.system(size: 29, weight: .bold))
                        .foregroundColor(.white)

                    Text("Track. Settle. Stay Connected.")
                        .font(.subheadline)
                        .foregroundColor(.white.opacity(0.65))
                }
                .opacity(animateLogo ? 1.0 : 0.0)

                // Loading Indicator

                ProgressView()
                    .tint(lightPurple)
                    .padding(.top, 15)
                    .opacity(animateLogo ? 1.0 : 0.0)
            }
        }
        .onAppear {
            withAnimation(.spring(duration: 0.9)) {
                animateLogo = true
            }
        }
    }
}
