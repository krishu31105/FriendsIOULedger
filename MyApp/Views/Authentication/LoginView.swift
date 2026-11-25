
import SwiftUI

struct LoginView: View {

    @ObservedObject var viewModel: LoginViewModel

    private let purple = Color(red: 0.58, green: 0.32, blue: 0.96)
    private let lightPurple = Color(red: 0.76, green: 0.58, blue: 1.0)

    var body: some View {

        ZStack {

            // MARK: Background

            backgroundView

            ScrollView(showsIndicators: false) {

                VStack(spacing: 25) {

                    Spacer(minLength: 35)

                    // MARK: App Branding

                    VStack(spacing: 12) {

                        Image("AppLogo")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 105, height: 105)
                            .clipShape(RoundedRectangle(cornerRadius: 25))
                            .shadow(color: purple.opacity(0.4), radius: 20)

                        Text("Friends IOU Ledger")
                            .font(.system(size: 28, weight: .bold))
                            .foregroundColor(.white)

                        Text("Your money. Your friends. Your balance.")
                            .font(.subheadline)
                            .foregroundColor(.white.opacity(0.55))
                            .multilineTextAlignment(.center)
                    }

                    Spacer(minLength: 10)

                    // MARK: Login Glass Card

                    VStack(spacing: 22) {

                        VStack(alignment: .leading, spacing: 6) {

                            Text("Welcome Back!")
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(.white)

                            Text("Login to manage your IOUs")
                                .font(.subheadline)
                                .foregroundColor(.white.opacity(0.5))
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)

                        // MARK: Face ID Button

                        Button {

                            Task {
                                await viewModel.authenticateWithFaceID()
                            }

                        } label: {

                            HStack(spacing: 12) {

                                if viewModel.isLoading {

                                    ProgressView()
                                        .tint(.white)

                                    Text("Authenticating...")

                                } else {

                                    Image(systemName: "faceid")
                                        .font(.title2)

                                    Text("Login with Face ID")
                                        .fontWeight(.semibold)
                                }
                            }
                            .frame(maxWidth: .infinity)
                            .frame(height: 56)
                            .background {
                                LinearGradient(
                                    colors: [purple, Color.purple],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            }
                            .foregroundColor(.white)
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                            .shadow(color: purple.opacity(0.3), radius: 12, y: 5)
                        }
                        .disabled(
                            viewModel.isLoading ||
                            viewModel.showManualLogin
                        )

                        // MARK: Divider

                        HStack(spacing: 12) {

                            Rectangle()
                                .fill(.white.opacity(0.15))
                                .frame(height: 1)

                            Text("OR LOGIN MANUALLY")
                                .font(.caption2)
                                .fontWeight(.semibold)
                                .tracking(1)
                                .foregroundColor(.white.opacity(0.45))
                                .fixedSize()

                            Rectangle()
                                .fill(.white.opacity(0.15))
                                .frame(height: 1)
                        }

                        // MARK: Username Field

                        VStack(alignment: .leading, spacing: 9) {

                            Text("USERNAME")
                                .font(.caption2)
                                .fontWeight(.bold)
                                .tracking(1)
                                .foregroundColor(.white.opacity(0.6))

                            HStack(spacing: 12) {

                                Image(systemName: "person")
                                    .foregroundColor(lightPurple)

                                TextField(
                                    "Enter your username",
                                    text: $viewModel.username
                                )
                                .textInputAutocapitalization(.never)
                                .autocorrectionDisabled()
                                .textContentType(.username)
                                .foregroundColor(.white)
                                .tint(lightPurple)
                            }
                            .padding()
                            .background(.white.opacity(0.07))
                            .clipShape(RoundedRectangle(cornerRadius: 14))
                            .overlay {
                                RoundedRectangle(cornerRadius: 14)
                                    .stroke(.white.opacity(0.12), lineWidth: 1)
                            }
                        }

                        // MARK: Password Field

                        VStack(alignment: .leading, spacing: 9) {

                            Text("PASSWORD")
                                .font(.caption2)
                                .fontWeight(.bold)
                                .tracking(1)
                                .foregroundColor(.white.opacity(0.6))

                            HStack(spacing: 12) {

                                Image(systemName: "lock")
                                    .foregroundColor(lightPurple)

                                SecureField(
                                    "Enter your password",
                                    text: $viewModel.password
                                )
                                .textContentType(.password)
                                .textInputAutocapitalization(.never)
                                .foregroundColor(.white)
                                .tint(lightPurple)
                            }
                            .padding()
                            .background(.white.opacity(0.07))
                            .clipShape(RoundedRectangle(cornerRadius: 14))
                            .overlay {
                                RoundedRectangle(cornerRadius: 14)
                                    .stroke(.white.opacity(0.12), lineWidth: 1)
                            }
                        }

                        // MARK: Login Button

                        Button {

                            viewModel.login()

                        } label: {

                            HStack {

                                Text("Login")
                                    .fontWeight(.bold)

                                Spacer()

                                Image(systemName: "arrow.right")
                                    .fontWeight(.bold)
                            }
                            .foregroundColor(.white)
                            .padding(.horizontal, 20)
                            .frame(maxWidth: .infinity)
                            .frame(height: 56)
                            .background {
                                LinearGradient(
                                    colors: [purple, lightPurple],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            }
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                            .shadow(color: purple.opacity(0.25), radius: 12, y: 5)
                        }

                        // MARK: Error Message

                        if !viewModel.errorMessage.isEmpty {

                            HStack(alignment: .top, spacing: 9) {

                                Image(systemName: "exclamationmark.circle.fill")
                                    .foregroundColor(.red)

                                Text(viewModel.errorMessage)
                                    .font(.footnote)
                                    .foregroundColor(.red.opacity(0.9))
                                    .multilineTextAlignment(.leading)

                                Spacer(minLength: 0)
                            }
                            .padding(12)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(Color.red.opacity(0.10))
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                        }
                    }
                    .padding(23)
                    .background {
                        RoundedRectangle(cornerRadius: 28)
                            .fill(.ultraThinMaterial)
                            .environment(\.colorScheme, .dark)
                            .overlay {
                                RoundedRectangle(cornerRadius: 28)
                                    .fill(.white.opacity(0.035))
                            }
                    }
                    .overlay {
                        RoundedRectangle(cornerRadius: 28)
                            .stroke(.white.opacity(0.14), lineWidth: 1)
                    }
                    .shadow(color: purple.opacity(0.12), radius: 25, y: 10)

                    // MARK: Footer

                    VStack(spacing: 7) {

                        Image(systemName: "heart.fill")
                            .foregroundColor(lightPurple.opacity(0.8))

                        Text("Keep your friendships and finances clear.")
                            .font(.caption)
                            .foregroundColor(.white.opacity(0.4))
                    }
                    .padding(.top, 5)

                    Spacer(minLength: 25)
                }
                .padding(.horizontal, 22)
            }
        }
        .preferredColorScheme(.dark)
    }

    // MARK: Background

    private var backgroundView: some View {

        ZStack {

            LinearGradient(
                colors: [
                    Color(red: 0.055, green: 0.035, blue: 0.11),
                    Color(red: 0.08, green: 0.06, blue: 0.16),
                    Color(red: 0.035, green: 0.035, blue: 0.08)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )

            Circle()
                .fill(purple.opacity(0.23))
                .frame(width: 260, height: 260)
                .blur(radius: 100)
                .offset(x: 150, y: -300)

            Circle()
                .fill(lightPurple.opacity(0.12))
                .frame(width: 220, height: 220)
                .blur(radius: 90)
                .offset(x: -150, y: 200)
        }
        .ignoresSafeArea()
    }
}

#Preview {
    LoginView(viewModel: LoginViewModel())
}
