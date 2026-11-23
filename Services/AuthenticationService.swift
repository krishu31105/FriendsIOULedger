
import Foundation
import LocalAuthentication

class AuthenticationService {

    func authenticate() async throws -> Bool {

        let context = LAContext()
        context.localizedCancelTitle = "Cancel"

        var error: NSError?

        guard context.canEvaluatePolicy(
            .deviceOwnerAuthenticationWithBiometrics,
            error: &error
        ) else {
            throw error ?? NSError(
                domain: "FaceID",
                code: 1,
                userInfo: [
                    NSLocalizedDescriptionKey: "Face ID is unavailable."
                ]
            )
        }

        return try await context.evaluatePolicy(
            .deviceOwnerAuthenticationWithBiometrics,
            localizedReason: "Authenticate to access Friends IOU Ledger"
        )
    }
}
