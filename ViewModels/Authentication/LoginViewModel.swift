
import Foundation
import Combine
import LocalAuthentication

@MainActor
class LoginViewModel: ObservableObject {

    // MARK: - Input Fields

    @Published var username = ""
    @Published var password = ""

    // MARK: - Authentication State

    @Published var isAuthenticated = false
    @Published var errorMessage = ""
    @Published var isLoading = false
    @Published var showManualLogin = false

    // MARK: - Face ID Attempts

    @Published var failedFaceIDAttempts = 0

    private let maximumFaceIDAttempts = 3
    private let authenticationService = AuthenticationService()

    // MARK: - Manual Login

    func login() {

        let enteredUsername = username.trimmingCharacters(
            in: .whitespacesAndNewlines
        )

        let enteredPassword = password.trimmingCharacters(
            in: .whitespacesAndNewlines
        )

        errorMessage = ""

        guard !enteredUsername.isEmpty else {
            errorMessage = "Please enter your username."
            return
        }

        guard !enteredPassword.isEmpty else {
            errorMessage = "Please enter your password."
            return
        }

        if enteredUsername == "admin" &&
            enteredPassword == "123456" {

            isAuthenticated = true
            errorMessage = ""
            failedFaceIDAttempts = 0

        } else {

            isAuthenticated = false
            errorMessage = "Invalid username or password."
        }
    }

    // MARK: - Face ID Authentication

    func authenticateWithFaceID() async {

        guard !showManualLogin else {
            return
        }

        isLoading = true
        errorMessage = ""

        defer {
            isLoading = false
        }

        do {

            let success = try await authenticationService.authenticate()

            if success {
                isAuthenticated = true
                errorMessage = ""
                failedFaceIDAttempts = 0
            }

        } catch {

            let authError = error as? LAError

            if authError?.code == .authenticationFailed {

                failedFaceIDAttempts += 1

                if failedFaceIDAttempts >= maximumFaceIDAttempts {

                    showManualLogin = true

                    errorMessage = """
                    Face ID failed 3 times.
                    Please login using your username and password.
                    """

                } else {

                    errorMessage = """
                    Face ID failed.
                    Attempt \(failedFaceIDAttempts) of 3.
                    Please try again.
                    """
                }

            } else if authError?.code == .biometryLockout {

                showManualLogin = true
                errorMessage = "Face ID is locked. Please login manually."

            } else if authError?.code == .userCancel ||
                        authError?.code == .systemCancel {

                errorMessage = "Authentication cancelled."

            } else {

                showManualLogin = true
                errorMessage = "Face ID unavailable. Please login manually."
            }
        }
    }

    // MARK: - Logout

    func logout() {

        isAuthenticated = false
        username = ""
        password = ""
        errorMessage = ""
        failedFaceIDAttempts = 0
        showManualLogin = false
    }
}
