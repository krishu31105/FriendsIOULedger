
import SwiftUI

struct AddIOUView: View {

    @ObservedObject var viewModel: IOUViewModel

    @Environment(\.dismiss) private var dismiss

    @State private var friendName = ""
    @State private var amount = ""
    @State private var selectedType: IOUType = .lent
    @State private var date = Date()
    @State private var reason = ""
    @State private var expectedReturnDate = Date()
    @State private var errorMessage = ""

    var body: some View {

        Form {

            Section("Friend Details") {

                TextField("Enter friend's name", text: $friendName)

                TextField("Enter amount", text: $amount)
                    .keyboardType(.decimalPad)
            }

            Section("Transaction Details") {

                Picker("Transaction Type", selection: $selectedType) {
                    ForEach(IOUType.allCases, id: \.self) { type in
                        Text(type.rawValue).tag(type)
                    }
                }

                DatePicker(
                    "Transaction Date",
                    selection: $date,
                    displayedComponents: .date
                )

                TextField("Enter reason", text: $reason)
            }

            Section("Return Details") {

                DatePicker(
                    "Expected Return Date",
                    selection: $expectedReturnDate,
                    displayedComponents: .date
                )
            }

            if !errorMessage.isEmpty {
                Text(errorMessage)
                    .foregroundColor(.red)
            }

            Section {

                Button("Save IOU") {
                    saveIOU()
                }
                .frame(maxWidth: .infinity)
                .fontWeight(.bold)
            }
        }
        .navigationTitle("Add New IOU")
        .navigationBarTitleDisplayMode(.inline)
    }

    private func saveIOU() {

        let trimmedName = friendName.trimmingCharacters(
            in: .whitespacesAndNewlines
        )

        let trimmedReason = reason.trimmingCharacters(
            in: .whitespacesAndNewlines
        )

        guard !trimmedName.isEmpty else {
            errorMessage = "Please enter friend's name."
            return
        }

        guard let enteredAmount = Double(amount),
              enteredAmount > 0 else {
            errorMessage = "Please enter a valid amount."
            return
        }

        guard !trimmedReason.isEmpty else {
            errorMessage = "Please enter the reason."
            return
        }

        let newEntry = IOUEntry(
            friendName: trimmedName,
            amount: enteredAmount,
            type: selectedType,
            date: date,
            reason: trimmedReason,
            expectedReturnDate: expectedReturnDate,
            amountPaid: 0
        )

        viewModel.addEntry(newEntry)

        dismiss()
    }
}

#Preview {
    NavigationStack {
        AddIOUView(viewModel: IOUViewModel())
    }
}
