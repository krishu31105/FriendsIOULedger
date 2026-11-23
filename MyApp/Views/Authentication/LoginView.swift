
import SwiftUI

struct LoginView: View {

    @ObservedObject var viewModel: LoginViewModel

    var body: some View {

        ZStack {

            Color(.systemGroupedBackground)
                .ignoresSafeArea()

            VStack(spacing: 22) {

                Spacer()

                Image(systemName: "person.2.fill")
                    .font(.system(size: 55))
                    .foregroundColor(.blue)

                Text("Friends IOU Ledger")
                    .font(.largeTitle)
                    .fontWeight(.bold)

                Text("Manage money between friends easily")
                    .foregroundColor(.secondary)

                Spacer()

                // Face ID Login

                Button {
                    Task {
                        await viewModel.authenticateWithFaceID()
                    }
                } label: {

                    Label(
                        "Login with Face ID",
                        systemImage: "faceid"
                    )
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(12)
                }
                .disabled(viewModel.isLoading || viewModel.showManualLogin)

                if viewModel.isLoading {
                    ProgressView("Authenticating...")
                }

                // Manual Login

                if viewModel.showManualLogin {

                    Text("Please use manual login.")
                        .foregroundColor(.orange)
                        .font(.subheadline)
                }

                Text("OR LOGIN MANUALLY")
                    .font(.caption)
                    .foregroundColor(.secondary)

                TextField("Enter username", text: $viewModel.username)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
                    .padding()
                    .background(Color.white)
                    .cornerRadius(10)

                SecureField("Enter password", text: $viewModel.password)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(10)

                Button {
                    viewModel.login()
                } label: {

                    Text("Login")
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                }

                if !viewModel.errorMessage.isEmpty {

                    Text(viewModel.errorMessage)
                        .font(.footnote)
                        .foregroundColor(.red)
                        .multilineTextAlignment(.center)
                }

                Spacer()
            }
            .padding(25)
        }
    }
}
