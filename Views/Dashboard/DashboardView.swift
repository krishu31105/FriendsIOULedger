
import SwiftUI

struct DashboardView: View {

    @ObservedObject var viewModel: IOUViewModel

    var body: some View {

        NavigationStack {

            ScrollView {

                VStack(alignment: .leading, spacing: 22) {

                    Text("Welcome!")
                        .font(.largeTitle)
                        .fontWeight(.bold)

                    Text("Your Friends IOU Dashboard")
                        .foregroundColor(.secondary)

                    amountCard(
                        title: "Total To Receive",
                        amount: viewModel.totalToReceive,
                        color: .green
                    )

                    amountCard(
                        title: "Total To Pay",
                        amount: viewModel.totalToPay,
                        color: .orange
                    )

                    amountCard(
                        title: "Pending Entries",
                        amount: Double(viewModel.pendingEntriesCount),
                        color: .blue,
                        isCount: true
                    )

                    VStack(alignment: .leading, spacing: 12) {

                        Text("Recent Transactions")
                            .font(.title2)
                            .fontWeight(.bold)

                        if viewModel.recentEntries.isEmpty {

                            Text("No recent transactions")
                                .foregroundColor(.secondary)

                        } else {

                            ForEach(viewModel.recentEntries) { entry in
                                transactionRow(entry)
                            }
                        }
                    }

                    VStack(spacing: 15) {

                        NavigationLink {
                            IOUListView(viewModel: viewModel)
                        } label: {
                            Label(
                                "View All IOUs",
                                systemImage: "list.bullet"
                            )
                            .fontWeight(.semibold)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(12)
                        }

                        NavigationLink {
                            AddIOUView(viewModel: viewModel)
                        } label: {
                            Label(
                                "Add New IOU",
                                systemImage: "plus.circle.fill"
                            )
                            .fontWeight(.semibold)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.green)
                            .foregroundColor(.white)
                            .cornerRadius(12)
                        }
                    }
                }
                .padding()
            }
            .navigationTitle("Dashboard")
        }
    }

    private func amountCard(
        title: String,
        amount: Double,
        color: Color,
        isCount: Bool = false
    ) -> some View {

        VStack(alignment: .leading, spacing: 8) {

            Text(title)
                .font(.headline)
                .foregroundColor(.secondary)

            if isCount {

                Text("\(Int(amount))")
                    .font(.largeTitle)
                    .fontWeight(.bold)

            } else {

                Text(
                    amount,
                    format: .currency(code: "INR")
                )
                .font(.largeTitle)
                .fontWeight(.bold)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(
            color.opacity(0.12),
            in: RoundedRectangle(cornerRadius: 15)
        )
    }

    private func transactionRow(_ entry: IOUEntry) -> some View {

        HStack {

            VStack(alignment: .leading, spacing: 5) {

                Text(entry.friendName)
                    .fontWeight(.semibold)

                Text(entry.type.rawValue)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }

            Spacer()

            VStack(alignment: .trailing, spacing: 5) {

                Text(
                    entry.amount,
                    format: .currency(code: "INR")
                )
                .fontWeight(.semibold)

                Text(entry.status.rawValue)
                    .font(.caption)
                    .foregroundColor(.blue)
            }
        }
        .padding()
        .background(
            Color(.secondarySystemBackground),
            in: RoundedRectangle(cornerRadius: 12)
        )
    }
}

#Preview {
    DashboardView(viewModel: IOUViewModel())
}
