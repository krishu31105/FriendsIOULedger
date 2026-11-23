
import SwiftUI

struct EditIOUView: View {

    @ObservedObject var viewModel: IOUViewModel

    @Environment(\.dismiss) private var dismiss

    let entry: IOUEntry

    @State private var friendName: String
    @State private var amount: String
    @State private var amountPaid: String
    @State private var reason: String
    @State private var expectedReturnDate: Date

    @State private var errorMessage = ""

    init(viewModel: IOUViewModel, entry: IOUEntry) {
        self.viewModel = viewModel
        self.entry = entry

        _friendName = State(initialValue: entry.friendName)
        _amount = State(initialValue: String(entry.amount))
        _amountPaid = State(initialValue: String(entry.amountPaid))
        _reason = State(initialValue: entry.reason)
        _expectedReturnDate = State(
            initialValue: entry.expectedReturnDate
        )
    }

    var body: some View {

        Form {

            Section("Friend Details") {

                TextField("Friend Name", text: $friendName)

                TextField("Amount", text: $amount)
                    .keyboardType(.decimalPad)

                TextField("Amount Paid", text: $amountPaid)
                    .keyboardType(.decimalPad)
            }

            Section("Transaction Information") {

                TextField("Reason", text: $reason)

                DatePicker(
                    "Expected Return Date",
                    selection: $expectedReturnDate,
                    displayedComponents: .date
                )
            }

            Section("Settlement Status") {

                if let total = Double(amount),
                   let paid = Double(amountPaid),
                   total > 0,
                   paid >= 0,
                   paid <= total {

                    let pending = total - paid

                    Text("Pending Amount: ₹\(String(format: "%.2f", pending))")

                    Text(
                        paid == 0 ? "Pending" :
                        paid == total ? "Settled" :
                        "Partially Settled"
                    )
                    .foregroundColor(.blue)

                } else {

                    Text("Enter valid amount and payment values.")
                        .foregroundColor(.red)
                }
            }

            if !errorMessage.isEmpty {
                Text(errorMessage)
                    .foregroundColor(.red)
            }

            Section {

                Button("Save Changes") {
                    updateIOU()
                }
                .fontWeight(.bold)
            }
        }
        .navigationTitle("Edit IOU")
        .navigationBarTitleDisplayMode(.inline)
    }

    private func updateIOU() {

        let name = friendName.trimmingCharacters(
            in: .whitespacesAndNewlines
        )

        let trimmedReason = reason.trimmingCharacters(
            in: .whitespacesAndNewlines
        )

        guard !name.isEmpty else {
            errorMessage = "Please enter friend name."
            return
        }

        guard !trimmedReason.isEmpty else {
            errorMessage = "Please enter a reason."
            return
        }

        guard let newAmount = Double(amount),
              newAmount > 0 else {
            errorMessage = "Enter a valid amount."
            return
        }

        guard let newAmountPaid = Double(amountPaid),
              newAmountPaid >= 0,
              newAmountPaid <= newAmount else {
            errorMessage = "Amount paid must be between zero and total amount."
            return
        }

        var updatedEntry = entry

        updatedEntry.friendName = name
        updatedEntry.amount = newAmount
        updatedEntry.amountPaid = newAmountPaid
        updatedEntry.reason = trimmedReason
        updatedEntry.expectedReturnDate = expectedReturnDate

        viewModel.updateEntry(updatedEntry)

        dismiss()
    }
}

#Preview {
    NavigationStack {
        EditIOUView(
            viewModel: IOUViewModel(),
            entry: IOUViewModel().entries[0]
        )
    }
}

