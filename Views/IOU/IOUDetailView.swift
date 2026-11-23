
import SwiftUI

struct IOUDetailView: View {

    @ObservedObject var viewModel: IOUViewModel

    let entry: IOUEntry

    var body: some View {

        ScrollView {

            VStack(alignment: .leading, spacing: 20) {

                VStack(spacing: 10) {

                    Image(systemName: "person.crop.circle.fill")
                        .font(.system(size: 55))
                        .foregroundColor(.blue)

                    Text(entry.friendName)
                        .font(.title)
                        .fontWeight(.bold)

                    Text(entry.type.rawValue)
                        .font(.headline)
                        .foregroundColor(
                            entry.type == .lent ? .green : .orange
                        )

                    Text(
                        entry.amount,
                        format: .currency(code: "INR")
                    )
                    .font(.largeTitle)
                    .fontWeight(.bold)
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(
                    Color(.secondarySystemBackground),
                    in: RoundedRectangle(cornerRadius: 15)
                )

                VStack(alignment: .leading, spacing: 15) {

                    Text("Transaction Information")
                        .font(.headline)

                    detailRow("Friend Name", entry.friendName)

                    detailRow("Type", entry.type.rawValue)

                    detailRow(
                        "Transaction Date",
                        entry.date.formatted(date: .long, time: .omitted)
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
                .padding()
                .background(
                    Color(.secondarySystemBackground),
                    in: RoundedRectangle(cornerRadius: 15)
                )

                VStack(alignment: .leading, spacing: 15) {

                    Text("Settlement Information")
                        .font(.headline)

                    detailRow(
                        "Total Amount",
                        "₹\(String(format: "%.2f", entry.amount))"
                    )

                    detailRow(
                        "Amount Paid",
                        "₹\(String(format: "%.2f", entry.amountPaid))"
                    )

                    detailRow(
                        "Pending Amount",
                        "₹\(String(format: "%.2f", entry.pendingAmount))"
                    )

                    detailRow(
                        "Status",
                        entry.status.rawValue
                    )
                }
                .padding()
                .background(
                    Color(.secondarySystemBackground),
                    in: RoundedRectangle(cornerRadius: 15)
                )

                NavigationLink {
                    EditIOUView(
                        viewModel: viewModel,
                        entry: entry
                    )
                } label: {
                    Label("Edit IOU", systemImage: "pencil")
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                }
            }
            .padding()
        }
        .navigationTitle("IOU Details")
        .navigationBarTitleDisplayMode(.inline)
    }

    private func detailRow(
        _ title: String,
        _ value: String
    ) -> some View {

        HStack(alignment: .top) {

            Text(title)
                .foregroundColor(.secondary)

            Spacer()

            Text(value)
                .fontWeight(.medium)
                .multilineTextAlignment(.trailing)
        }
    }
}

#Preview {
    NavigationStack {
        IOUDetailView(
            viewModel: IOUViewModel(),
            entry: IOUViewModel().entries[0]
        )
    }
}
