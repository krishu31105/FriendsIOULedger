
import SwiftUI

struct IOUDetailView: View {

    @ObservedObject var viewModel: IOUViewModel
    let entry: IOUEntry

    private let purple = Color(red: 0.55, green: 0.35, blue: 0.95)
    private let lightPurple = Color(red: 0.72, green: 0.55, blue: 1.0)

    private var progress: Double {
        guard entry.amount > 0 else { return 0 }
        return min(max(entry.amountPaid / entry.amount, 0), 1)
    }

    private var transactionColor: Color {
        entry.type == .lent ? .green : .orange
    }

    var body: some View {

        ZStack {
            LinearGradient(
                colors: [
                    Color(red: 0.07, green: 0.05, blue: 0.14),
                    Color(red: 0.13, green: 0.08, blue: 0.25),
                    Color(red: 0.06, green: 0.06, blue: 0.12)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            ScrollView {
                VStack(spacing: 22) {

                    // MARK: - Main Amount Card

                    VStack(spacing: 14) {

                        Image(systemName: "person.crop.circle.fill")
                            .font(.system(size: 65))
                            .foregroundStyle(
                                LinearGradient(
                                    colors: [lightPurple, purple],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )

                        Text(entry.friendName)
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.white)

                        Text(entry.type.rawValue.uppercased())
                            .font(.caption)
                            .fontWeight(.bold)
                            .tracking(1.5)
                            .foregroundColor(transactionColor)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 7)
                            .background(transactionColor.opacity(0.15))
                            .clipShape(Capsule())

                        Text(
                            entry.amount,
                            format: .currency(code: "INR")
                        )
                        .font(.system(size: 34, weight: .bold))
                        .foregroundColor(.white)

                        Text("Total Transaction Amount")
                            .font(.subheadline)
                            .foregroundColor(.white.opacity(0.6))
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 28)
                    .glassCard()

                    // MARK: - Transaction Information

                    VStack(alignment: .leading, spacing: 18) {

                        sectionTitle(
                            "Transaction Information",
                            icon: "doc.text"
                        )

                        detailRow("Friend Name", entry.friendName)
                        detailRow("Transaction Type", entry.type.rawValue)

                        detailRow(
                            "Transaction Date",
                            entry.date.formatted(
                                date: .long,
                                time: .omitted
                            )
                        )

                        detailRow("Reason", entry.reason)

                        detailRow(
                            "Expected Return",
                            entry.expectedReturnDate.formatted(
                                date: .long,
                                time: .omitted
                            )
                        )
                    }
                    .padding(20)
                    .glassCard()

                    // MARK: - Settlement Information

                    VStack(alignment: .leading, spacing: 18) {

                        sectionTitle(
                            "Settlement Information",
                            icon: "chart.pie"
                        )

                        detailRow(
                            "Total Amount",
                            entry.amount.formatted(.currency(code: "INR"))
                        )

                        detailRow(
                            "Amount Paid",
                            entry.amountPaid.formatted(.currency(code: "INR"))
                        )

                        detailRow(
                            "Pending Amount",
                            entry.pendingAmount.formatted(.currency(code: "INR"))
                        )

                        Divider()
                            .overlay(Color.white.opacity(0.15))

                        VStack(alignment: .leading, spacing: 10) {

                            HStack {
                                Text("Payment Progress")
                                    .foregroundColor(.white.opacity(0.7))

                                Spacer()

                                Text("\(Int(progress * 100))%")
                                    .fontWeight(.bold)
                                    .foregroundColor(lightPurple)
                            }

                            GeometryReader { geometry in
                                ZStack(alignment: .leading) {

                                    Capsule()
                                        .fill(Color.white.opacity(0.12))

                                    Capsule()
                                        .fill(
                                            LinearGradient(
                                                colors: [purple, lightPurple],
                                                startPoint: .leading,
                                                endPoint: .trailing
                                            )
                                        )
                                        .frame(
                                            width: geometry.size.width * progress
                                        )
                                }
                            }
                            .frame(height: 9)
                        }

                        HStack {
                            Image(
                                systemName: entry.status.rawValue == "Settled"
                                ? "checkmark.circle.fill"
                                : "clock.fill"
                            )
                            .foregroundColor(
                                entry.status.rawValue == "Settled"
                                ? .green
                                : .orange
                            )

                            Text("Status")
                                .foregroundColor(.white.opacity(0.7))

                            Spacer()

                            Text(entry.status.rawValue)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                        }
                    }
                    .padding(20)
                    .glassCard()

                    // MARK: - Edit Button

                    NavigationLink {
                        EditIOUView(
                            viewModel: viewModel,
                            entry: entry
                        )
                    } label: {

                        HStack(spacing: 10) {
                            Image(systemName: "pencil")
                            Text("Edit IOU")
                        }
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(
                            LinearGradient(
                                colors: [purple, lightPurple],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                    }
                    .padding(.top, 4)
                }
                .padding()
            }
        }
        .navigationTitle("IOU Details")
        .navigationBarTitleDisplayMode(.inline)
        .toolbarColorScheme(.dark, for: .navigationBar)
    }

    // MARK: - Section Title

    private func sectionTitle(
        _ title: String,
        icon: String
    ) -> some View {

        HStack(spacing: 10) {
            Image(systemName: icon)
                .foregroundColor(lightPurple)

            Text(title)
                .font(.headline)
                .foregroundColor(.white)
        }
    }

    // MARK: - Detail Row

    private func detailRow(
        _ title: String,
        _ value: String
    ) -> some View {

        HStack(alignment: .top) {

            Text(title)
                .foregroundColor(.white.opacity(0.55))

            Spacer()

            Text(value.isEmpty ? "Not provided" : value)
                .fontWeight(.medium)
                .foregroundColor(.white)
                .multilineTextAlignment(.trailing)
        }
        .font(.subheadline)
    }
}

// MARK: - Glass Card Style

extension View {
    func glassCard() -> some View {
        self
            .background(Color.white.opacity(0.07))
            .clipShape(RoundedRectangle(cornerRadius: 22))
            .overlay(
                RoundedRectangle(cornerRadius: 22)
                    .stroke(
                        Color.white.opacity(0.12),
                        lineWidth: 1
                    )
            )
    }
}

#Preview {
    let viewModel = IOUViewModel()

    NavigationStack {
        if let entry = viewModel.entries.first {
            IOUDetailView(
                viewModel: viewModel,
                entry: entry
            )
        } else {
            Text("No IOU entries available")
        }
    }
}
