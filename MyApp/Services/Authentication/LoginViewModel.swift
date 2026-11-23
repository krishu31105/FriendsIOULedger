import Foundation
import Combine

class LoginViewModel: ObservableObject {

    @Published var email = ""
    @Published var password = ""

    @Published var errorMessage = ""
    @Published var isLoginValid = false

    func validateLogin() {

        errorMessage = ""
        isLoginValid = false

        if email.isEmpty {
            errorMessage = "Please enter your email"
            return
        }

        if !email.contains("@") || !email.contains(".") {
            errorMessage = "Please enter a valid email"
            return
        }

        if password.isEmpty {
            errorMessage = "Please enter your password"
            return
        }

        if password.count < 6 {
            errorMessage = "Password must contain at least 6 characters"
            return
        }

        isLoginValid = true
        errorMessage = "Input validation successful!"
    }
}

