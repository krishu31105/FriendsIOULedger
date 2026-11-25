
import SwiftUI
import UIKit

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
    @State private var showSaveSuccess = false

    private let purple = Color(red: 0.55, green: 0.35, blue: 0.95)
    private let lightPurple = Color(red: 0.72, green: 0.55, blue: 1.0)

    init(viewModel: IOUViewModel, entry: IOUEntry) {
        self.viewModel = viewModel
        self.entry = entry

        _friendName = State(initialValue: entry.friendName)
        _amount = State(initialValue: String(entry.amount))
        _amountPaid = State(initialValue: String(entry.amountPaid))
        _reason = State(initialValue: entry.reason)
        _expectedReturnDate = State(initialValue: entry.expectedReturnDate)
    }

    private var validAmounts: (total: Double, paid: Double)? {
        guard let total = Double(amount),
              let paid = Double(amountPaid),
              total > 0,
              paid >= 0,
              paid <= total else {
            return nil
        }

        return (total, paid)
    }

    private var settlementStatus: String {
        guard let values = validAmounts else {
            return "Invalid Amount"
        }

        if values.paid == 0 {
            return "Pending"
        } else if values.paid == values.total {
            return "Settled"
        } else {
            return "Partially Settled"
        }
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

                    // MARK: - Header

                    VStack(alignment: .leading, spacing: 8) {

                        Text("UPDATE TRANSACTION")
                            .font(.caption)
                            .fontWeight(.bold)
                            .tracking(2)
                            .foregroundColor(lightPurple)

                        Text("Edit IOU")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(.white)

                        Text("Update your transaction details below.")
                            .font(.subheadline)
                            .foregroundColor(.white.opacity(0.6))
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)

                    // MARK: - Friend Details

                    VStack(alignment: .leading, spacing: 18) {

                        sectionTitle("Friend Details", icon: "person")

                        customTextField(
                            title: "Friend Name",
                            placeholder: "Enter friend's name",
                            text: $friendName,
                            icon: "person.fill"
                        )

                        customTextField(
                            title: "Total Amount",
                            placeholder: "Enter total amount",
                            text: $amount,
                            icon: "indianrupeesign.circle.fill",
                            keyboard: .decimalPad
                        )

                        customTextField(
                            title: "Amount Paid",
                            placeholder: "Enter amount already paid",
                            text: $amountPaid,
                            icon: "checkmark.circle.fill",
                            keyboard: .decimalPad
                        )
                    }
                    .padding(20)
                    .glassCard()

                    // MARK: - Transaction Information

                    VStack(alignment: .leading, spacing: 18) {

                        sectionTitle(
                            "Transaction Information",
                            icon: "doc.text"
                        )

                        VStack(alignment: .leading, spacing: 9) {

                            Text("Reason")
                                .font(.caption)
                                .foregroundColor(.white.opacity(0.6))

                            HStack(alignment: .top, spacing: 12) {

                                Image(systemName: "text.alignleft")
                                    .foregroundColor(lightPurple)
                                    .padding(.top, 12)

                                TextField(
                                    "Enter transaction reason",
                                    text: $reason,
                                    axis: .vertical
                                )
                                .lineLimit(3...5)
                                .foregroundColor(.white)
                            }
                            .padding(14)
                            .background(Color.white.opacity(0.07))
                            .clipShape(RoundedRectangle(cornerRadius: 13))
                        }

                        VStack(alignment: .leading, spacing: 10) {

                            Text("Expected Return Date")
                                .font(.caption)
                                .foregroundColor(.white.opacity(0.6))

                            DatePicker(
                                "Return Date",
                                selection: $expectedReturnDate,
                                displayedComponents: .date
                            )
                            .datePickerStyle(.compact)
                            .tint(lightPurple)
                            .colorScheme(.dark)
                        }
                    }
                    .padding(20)
                    .glassCard()

                    // MARK: - Settlement Preview

                    VStack(alignment: .leading, spacing: 18) {

                        sectionTitle(
                            "Settlement Preview",
                            icon: "chart.pie"
                        )

                        if let values = validAmounts {

                            previewRow("Total Amount", values.total)
                            previewRow("Amount Paid", values.paid)
                            previewRow(
                                "Pending Amount",
                                values.total - values.paid
                            )

                            Divider()
                                .overlay(Color.white.opacity(0.15))

                            HStack {

                                Text("Current Status")
                                    .foregroundColor(.white.opacity(0.65))

                                Spacer()

                                Text(settlementStatus)
                                    .fontWeight(.bold)
                                    .foregroundColor(
                                        values.paid == values.total
                                        ? .green
                                        : values.paid > 0
                                        ? .orange
                                        : lightPurple
                                    )
                            }

                        } else {

                            Text("Enter valid amount and payment values.")
                                .font(.subheadline)
                                .foregroundColor(.red)
                        }
                    }
                    .padding(20)
                    .glassCard()

                    // MARK: - Error Message

                    if !errorMessage.isEmpty {

                        HStack(spacing: 10) {

                            Image(systemName: "exclamationmark.circle.fill")

                            Text(errorMessage)
                                .font(.subheadline)
                        }
                        .foregroundColor(.red)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(14)
                        .background(Color.red.opacity(0.12))
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                    }

                    // MARK: - Save Button

                    Button {
                        updateIOU()
                    } label: {

                        HStack(spacing: 10) {
                            Image(systemName: "checkmark.circle.fill")
                            Text("Save Changes")
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
        .navigationTitle("Edit IOU")
        .navigationBarTitleDisplayMode(.inline)
        .toolbarColorScheme(.dark, for: .navigationBar)
        .alert("Changes Saved!", isPresented: $showSaveSuccess) {
            Button("OK") {
                dismiss()
            }
        } message: {
            Text("Your IOU transaction has been updated successfully.")
        }
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

    // MARK: - Custom Text Field

    private func customTextField(
        title: String,
        placeholder: String,
        text: Binding<String>,
        icon: String,
        keyboard: UIKeyboardType = .default
    ) -> some View {

        VStack(alignment: .leading, spacing: 9) {

            Text(title)
                .font(.caption)
                .foregroundColor(.white.opacity(0.6))

            HStack(spacing: 12) {

                Image(systemName: icon)
                    .foregroundColor(lightPurple)

                TextField(placeholder, text: text)
                    .keyboardType(keyboard)
                    .foregroundColor(.white)
            }
            .padding(14)
            .background(Color.white.opacity(0.07))
            .clipShape(RoundedRectangle(cornerRadius: 13))
        }
    }

    // MARK: - Preview Row

    private func previewRow(
        _ title: String,
        _ value: Double
    ) -> some View {

        HStack {

            Text(title)
                .foregroundColor(.white.opacity(0.65))

            Spacer()

            Text(value, format: .currency(code: "INR"))
                .fontWeight(.medium)
                .foregroundColor(.white)
        }
        .font(.subheadline)
    }

    // MARK: - Update IOU

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

        errorMessage = ""
        showSaveSuccess = true
    }
}

#Preview {
    let viewModel = IOUViewModel()

    NavigationStack {
        if let entry = viewModel.entries.first {
            EditIOUView(
                viewModel: viewModel,
                entry: entry
            )
        } else {
            Text("No IOU entries available")
        }
    }
}
