
import SwiftUI

struct DashboardView: View {

    @ObservedObject var viewModel: IOUViewModel

    private let purple = Color(red: 0.58, green: 0.32, blue: 0.96)
    private let lightPurple = Color(red: 0.76, green: 0.58, blue: 1.0)

    var body: some View {

        NavigationStack {

            ZStack {

                // MARK: Background

                LinearGradient(
                    colors: [
                        Color(red: 0.055, green: 0.035, blue: 0.11),
                        Color(red: 0.08, green: 0.06, blue: 0.16),
                        Color(red: 0.035, green: 0.035, blue: 0.08)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()

                Circle()
                    .fill(purple.opacity(0.22))
                    .frame(width: 260, height: 260)
                    .blur(radius: 100)
                    .offset(x: 150, y: -350)

                Circle()
                    .fill(lightPurple.opacity(0.12))
                    .frame(width: 220, height: 220)
                    .blur(radius: 90)
                    .offset(x: -150, y: 100)

                // MARK: Main Content

                ScrollView(showsIndicators: false) {

                    VStack(alignment: .leading, spacing: 26) {

                        // Header

                        headerSection

                        // Main Balance Card

                        balanceCard

                        // Financial Summary

                        VStack(alignment: .leading, spacing: 15) {

                            sectionHeader("Your Overview", subtitle: "Track your money")

                            HStack(spacing: 14) {

                                summaryCard(
                                    title: "To Receive",
                                    amount: viewModel.totalToReceive,
                                    icon: "arrow.down.left",
                                    color: .green
                                )

                                summaryCard(
                                    title: "To Pay",
                                    amount: viewModel.totalToPay,
                                    icon: "arrow.up.right",
                                    color: .orange
                                )
                            }

                            pendingCard
                        }

                        // Recent Transactions

                        VStack(alignment: .leading, spacing: 15) {

                            sectionHeader(
                                "Recent Activity",
                                subtitle: "Your latest transactions"
                            )

                            if viewModel.recentEntries.isEmpty {

                                emptyTransactions

                            } else {

                                VStack(spacing: 12) {

                                    ForEach(viewModel.recentEntries) { entry in
                                        transactionRow(entry)
                                    }
                                }
                            }
                        }

                        // Action Buttons

                        VStack(spacing: 13) {

                            NavigationLink {
                                AddIOUView(viewModel: viewModel)
                            } label: {

                                HStack {

                                    Image(systemName: "plus")
                                        .font(.headline)

                                    Text("Add New IOU")
                                        .fontWeight(.bold)

                                    Spacer()

                                    Image(systemName: "arrow.up.right")
                                        .font(.subheadline)
                                }
                                .foregroundColor(.white)
                                .padding(.horizontal, 20)
                                .frame(height: 58)
                                .background {
                                    LinearGradient(
                                        colors: [purple, Color.purple],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                }
                                .clipShape(RoundedRectangle(cornerRadius: 18))
                                .shadow(color: purple.opacity(0.35), radius: 15, y: 6)
                            }

                            NavigationLink {
                                IOUListView(viewModel: viewModel)
                            } label: {

                                HStack {

                                    Image(systemName: "square.grid.2x2")
                                    Text("View All Transactions")
                                        .fontWeight(.semibold)

                                    Spacer()

                                    Image(systemName: "chevron.right")
                                        .font(.caption)
                                }
                                .foregroundColor(.white.opacity(0.85))
                                .padding()
                                .frame(height: 54)
                                .background(glassBackground)
                                .clipShape(RoundedRectangle(cornerRadius: 18))
                                .overlay {
                                    RoundedRectangle(cornerRadius: 18)
                                        .stroke(.white.opacity(0.10), lineWidth: 1)
                                }
                            }
                        }

                        Text("Friends IOU Ledger • Manage money easily")
                            .font(.caption2)
                            .foregroundColor(.white.opacity(0.35))
                            .frame(maxWidth: .infinity)
                            .padding(.top, 5)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 18)
                    .padding(.bottom, 30)
                }
            }
            .toolbar(.hidden, for: .navigationBar)
        }
        .preferredColorScheme(.dark)
    }

    // MARK: Header

    private var headerSection: some View {

        HStack {

            VStack(alignment: .leading, spacing: 7) {

                Text("HELLO THERE 👋")
                    .font(.caption)
                    .fontWeight(.bold)
                    .tracking(2)
                    .foregroundColor(lightPurple)

                Text("Your Dashboard")
                    .font(.system(size: 29, weight: .bold))
                    .foregroundColor(.white)

                Text("Keep your friendships and finances clear.")
                    .font(.subheadline)
                    .foregroundColor(.white.opacity(0.55))
            }

            Spacer()

            Image(systemName: "wallet.pass.fill")
                .font(.title2)
                .foregroundStyle(
                    LinearGradient(
                        colors: [lightPurple, purple],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(width: 54, height: 54)
                .background(.white.opacity(0.08))
                .clipShape(RoundedRectangle(cornerRadius: 18))
                .overlay {
                    RoundedRectangle(cornerRadius: 18)
                        .stroke(.white.opacity(0.15), lineWidth: 1)
                }
        }
    }

    // MARK: Main Balance Card

    private var balanceCard: some View {

        VStack(alignment: .leading, spacing: 22) {

            HStack {

                Label("TOTAL OUTSTANDING", systemImage: "chart.pie.fill")
                    .font(.caption)
                    .fontWeight(.bold)
                    .tracking(1.2)
                    .foregroundColor(.white.opacity(0.75))

                Spacer()

                Image(systemName: "ellipsis")
                    .foregroundColor(.white.opacity(0.8))
            }

            VStack(alignment: .leading, spacing: 6) {

                Text("Net Balance")
                    .font(.subheadline)
                    .foregroundColor(.white.opacity(0.65))

                Text(
                    viewModel.totalToReceive - viewModel.totalToPay,
                    format: .currency(code: "INR")
                )
                .font(.system(size: 34, weight: .bold, design: .rounded))
                .foregroundColor(.white)
                .minimumScaleFactor(0.7)
                .lineLimit(1)
            }

            Rectangle()
                .fill(.white.opacity(0.20))
                .frame(height: 1)

            HStack {

                VStack(alignment: .leading, spacing: 5) {

                    Text("YOU WILL RECEIVE")
                        .font(.system(size: 9, weight: .bold))
                        .tracking(1)
                        .foregroundColor(.white.opacity(0.65))

                    Text(
                        viewModel.totalToReceive,
                        format: .currency(code: "INR")
                    )
                    .font(.headline)
                    .foregroundColor(.white)
                }

                Spacer()

                VStack(alignment: .trailing, spacing: 5) {

                    Text("YOU WILL PAY")
                        .font(.system(size: 9, weight: .bold))
                        .tracking(1)
                        .foregroundColor(.white.opacity(0.65))

                    Text(
                        viewModel.totalToPay,
                        format: .currency(code: "INR")
                    )
                    .font(.headline)
                    .foregroundColor(.white)
                }
            }
        }
        .padding(22)
        .background {
            ZStack {

                RoundedRectangle(cornerRadius: 25)
                    .fill(.ultraThinMaterial)

                LinearGradient(
                    colors: [
                        purple.opacity(0.75),
                        Color(red: 0.32, green: 0.16, blue: 0.62).opacity(0.85),
                        Color(red: 0.15, green: 0.12, blue: 0.30).opacity(0.9)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )

                Circle()
                    .fill(.white.opacity(0.10))
                    .frame(width: 150, height: 150)
                    .blur(radius: 2)
                    .offset(x: 140, y: -80)
            }
        }
        .clipShape(RoundedRectangle(cornerRadius: 25))
        .overlay {
            RoundedRectangle(cornerRadius: 25)
                .stroke(.white.opacity(0.22), lineWidth: 1)
        }
        .shadow(color: purple.opacity(0.22), radius: 22, y: 10)
    }

    // MARK: Summary Cards

    private func summaryCard(
        title: String,
        amount: Double,
        icon: String,
        color: Color
    ) -> some View {

        VStack(alignment: .leading, spacing: 16) {

            Image(systemName: icon)
                .font(.headline)
                .foregroundColor(color)
                .frame(width: 42, height: 42)
                .background(color.opacity(0.13))
                .clipShape(RoundedRectangle(cornerRadius: 13))

            VStack(alignment: .leading, spacing: 5) {

                Text(title)
                    .font(.subheadline)
                    .foregroundColor(.white.opacity(0.55))

                Text(amount, format: .currency(code: "INR"))
                    .font(.system(size: 19, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                    .minimumScaleFactor(0.7)
                    .lineLimit(1)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(17)
        .background(glassBackground)
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .overlay {
            RoundedRectangle(cornerRadius: 20)
                .stroke(.white.opacity(0.10), lineWidth: 1)
        }
    }

    // MARK: Pending Card

    private var pendingCard: some View {

        HStack(spacing: 14) {

            Image(systemName: "clock.arrow.circlepath")
                .font(.title2)
                .foregroundColor(lightPurple)
                .frame(width: 46, height: 46)
                .background(purple.opacity(0.18))
                .clipShape(RoundedRectangle(cornerRadius: 14))

            VStack(alignment: .leading, spacing: 4) {

                Text("Pending Transactions")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)

                Text("Transactions waiting for settlement")
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.5))
            }

            Spacer()

            Text("\(viewModel.pendingEntriesCount)")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(lightPurple)
        }
        .padding(16)
        .background(glassBackground)
        .clipShape(RoundedRectangle(cornerRadius: 18))
        .overlay {
            RoundedRectangle(cornerRadius: 18)
                .stroke(purple.opacity(0.22), lineWidth: 1)
        }
    }

    // MARK: Section Header

    private func sectionHeader(
        _ title: String,
        subtitle: String
    ) -> some View {

        VStack(alignment: .leading, spacing: 5) {

            Text(title)
                .font(.title3)
                .fontWeight(.bold)
                .foregroundColor(.white)

            Text(subtitle)
                .font(.caption)
                .foregroundColor(.white.opacity(0.45))
        }
    }

    // MARK: Transaction Row

    private func transactionRow(_ entry: IOUEntry) -> some View {

        let isLent = entry.type == .lent
        let transactionColor: Color = isLent ? .green : .orange

        return HStack(spacing: 13) {

            Image(systemName: isLent ? "arrow.up.right" : "arrow.down.left")
                .font(.headline)
                .foregroundColor(transactionColor)
                .frame(width: 44, height: 44)
                .background(transactionColor.opacity(0.13))
                .clipShape(RoundedRectangle(cornerRadius: 14))

            VStack(alignment: .leading, spacing: 5) {

                Text(entry.friendName)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)

                Text(entry.reason)
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.5))
                    .lineLimit(1)
            }

            Spacer(minLength: 5)

            VStack(alignment: .trailing, spacing: 5) {

                Text(
                    entry.amount,
                    format: .currency(code: "INR")
                )
                .font(.subheadline)
                .fontWeight(.bold)
                .foregroundColor(.white)

                Text(entry.status.rawValue)
                    .font(.system(size: 10, weight: .medium))
                    .foregroundColor(lightPurple)
                    .padding(.horizontal, 9)
                    .padding(.vertical, 4)
                    .background(purple.opacity(0.16))
                    .clipShape(Capsule())
            }
        }
        .padding(15)
        .background(glassBackground)
        .clipShape(RoundedRectangle(cornerRadius: 18))
        .overlay {
            RoundedRectangle(cornerRadius: 18)
                .stroke(.white.opacity(0.08), lineWidth: 1)
        }
    }

    // MARK: Empty State

    private var emptyTransactions: some View {

        VStack(spacing: 10) {

            Image(systemName: "tray")
                .font(.largeTitle)
                .foregroundColor(lightPurple)

            Text("No transactions yet")
                .font(.headline)
                .foregroundColor(.white)

            Text("Your recent IOUs will appear here.")
                .font(.caption)
                .foregroundColor(.white.opacity(0.5))
        }
        .frame(maxWidth: .infinity)
        .padding(30)
        .background(glassBackground)
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }

    // MARK: Glass Background

    private var glassBackground: some View {

        RoundedRectangle(cornerRadius: 20)
            .fill(.ultraThinMaterial)
            .environment(\.colorScheme, .dark)
            .overlay {
                RoundedRectangle(cornerRadius: 20)
                    .fill(.white.opacity(0.035))
            }
    }
}

#Preview {
    DashboardView(viewModel: IOUViewModel())
}
