
import SwiftUI

struct ContentView: View {

    @StateObject private var loginViewModel = LoginViewModel()

    @StateObject private var iouViewModel = IOUViewModel()

    var body: some View {

        Group {

            if loginViewModel.isAuthenticated {

                DashboardView(viewModel: iouViewModel)

            } else {

                LoginView(viewModel: loginViewModel)
            }
        }
    }
}

#Preview {
    ContentView()
}

