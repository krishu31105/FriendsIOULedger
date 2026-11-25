
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

    private let purple = Color(red: 0.58, green: 0.32, blue: 0.96)
    private let lightPurple = Color(red: 0.76, green: 0.58, blue: 1.0)

    var body: some View {

        ZStack {

            backgroundView

            ScrollView(showsIndicators: false) {

                VStack(alignment: .leading, spacing: 25) {

                    // MARK: Header

                    VStack(alignment: .leading, spacing: 7) {

                        Text("NEW TRANSACTION")
                            .font(.caption)
                            .fontWeight(.bold)
                            .tracking(2)
                            .foregroundColor(lightPurple)

                        Text("Add New IOU")
                            .font(.system(size: 28, weight: .bold))
                            .foregroundColor(.white)

                        Text("Record money shared between friends.")
                            .font(.subheadline)
                            .foregroundColor(.white.opacity(0.55))
                    }
                    .padding(.top, 10)

                    // MARK: Friend Details

                    VStack(alignment: .leading, spacing: 15) {

                        sectionTitle("Friend Details", icon: "person.fill")

                        VStack(alignment: .leading, spacing: 9) {

                            fieldLabel("FRIEND NAME")

                            HStack(spacing: 12) {

                                Image(systemName: "person")
                                    .foregroundColor(lightPurple)

                                TextField(
                                    "Enter friend's name",
                                    text: $friendName
                                )
                                .foregroundColor(.white)
                                .tint(lightPurple)
                                .textInputAutocapitalization(.words)
                                .autocorrectionDisabled()
                            }
                            .padding()
                            .background(glassBackground)
                            .clipShape(RoundedRectangle(cornerRadius: 15))
                            .overlay {
                                RoundedRectangle(cornerRadius: 15)
                                    .stroke(.white.opacity(0.10), lineWidth: 1)
                            }
                        }

                        VStack(alignment: .leading, spacing: 9) {

                            fieldLabel("AMOUNT")

                            HStack(spacing: 12) {

                                Text("₹")
                                    .font(.title2)
                                    .fontWeight(.bold)
                                    .foregroundColor(lightPurple)

                                TextField("Enter amount", text: $amount)
                                    .keyboardType(.decimalPad)
                                    .font(.title3)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.white)
                                    .tint(lightPurple)
                            }
                            .padding()
                            .background(glassBackground)
                            .clipShape(RoundedRectangle(cornerRadius: 15))
                            .overlay {
                                RoundedRectangle(cornerRadius: 15)
                                    .stroke(.white.opacity(0.10), lineWidth: 1)
                            }
                        }
                    }

                    // MARK: Transaction Type

                    VStack(alignment: .leading, spacing: 15) {

                        sectionTitle("Transaction Type", icon: "arrow.left.arrow.right")

                        HStack(spacing: 13) {

                            typeCard(
                                title: "I Lent",
                                subtitle: "Money I gave",
                                icon: "arrow.up.right",
                                type: .lent,
                                color: .green
                            )

                            typeCard(
                                title: "I Borrowed",
                                subtitle: "Money I received",
                                icon: "arrow.down.left",
                                type: .borrowed,
                                color: .orange
                            )
                        }
                    }

                    // MARK: Transaction Information

                    VStack(alignment: .leading, spacing: 15) {

                        sectionTitle("Transaction Details", icon: "calendar")

                        VStack(alignment: .leading, spacing: 9) {

                            fieldLabel("TRANSACTION DATE")

                            DatePicker(
                                "Transaction Date",
                                selection: $date,
                                displayedComponents: .date
                            )
                            .datePickerStyle(.compact)
                            .tint(lightPurple)
                            .foregroundColor(.white)
                            .padding()
                            .background(glassBackground)
                            .clipShape(RoundedRectangle(cornerRadius: 15))
                        }

                        VStack(alignment: .leading, spacing: 9) {

                            fieldLabel("EXPECTED RETURN DATE")

                            DatePicker(
                                "Expected Return Date",
                                selection: $expectedReturnDate,
                                displayedComponents: .date
                            )
                            .datePickerStyle(.compact)
                            .tint(lightPurple)
                            .foregroundColor(.white)
                            .padding()
                            .background(glassBackground)
                            .clipShape(RoundedRectangle(cornerRadius: 15))
                        }

                        VStack(alignment: .leading, spacing: 9) {

                            fieldLabel("REASON")

                            HStack(alignment: .top, spacing: 12) {

                                Image(systemName: "text.alignleft")
                                    .foregroundColor(lightPurple)
                                    .padding(.top, 3)

                                TextField(
                                    "Why was the money exchanged?",
                                    text: $reason,
                                    axis: .vertical
                                )
                                .lineLimit(2...4)
                                .foregroundColor(.white)
                                .tint(lightPurple)
                            }
                            .padding()
                            .background(glassBackground)
                            .clipShape(RoundedRectangle(cornerRadius: 15))
                            .overlay {
                                RoundedRectangle(cornerRadius: 15)
                                    .stroke(.white.opacity(0.10), lineWidth: 1)
                            }
                        }
                    }

                    // MARK: Error Message

                    if !errorMessage.isEmpty {

                        HStack(alignment: .top, spacing: 10) {

                            Image(systemName: "exclamationmark.circle.fill")
                                .foregroundColor(.red)

                            Text(errorMessage)
                                .font(.footnote)
                                .foregroundColor(.red.opacity(0.9))

                            Spacer()
                        }
                        .padding(13)
                        .background(Color.red.opacity(0.10))
                        .clipShape(RoundedRectangle(cornerRadius: 13))
                    }

                    // MARK: Save Button

                    Button {

                        saveIOU()

                    } label: {

                        HStack {

                            Image(systemName: "checkmark.circle.fill")

                            Text("Save IOU")
                                .fontWeight(.bold)

                            Spacer()

                            Image(systemName: "arrow.right")
                                .fontWeight(.bold)
                        }
                        .foregroundColor(.white)
                        .padding(.horizontal, 20)
                        .frame(maxWidth: .infinity)
                        .frame(height: 58)
                        .background {
                            LinearGradient(
                                colors: [purple, lightPurple],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        }
                        .clipShape(RoundedRectangle(cornerRadius: 17))
                        .shadow(color: purple.opacity(0.3), radius: 15, y: 6)
                    }

                    Text("Your transaction will be saved securely on this device.")
                        .font(.caption2)
                        .foregroundColor(.white.opacity(0.4))
                        .frame(maxWidth: .infinity)
                        .multilineTextAlignment(.center)
                }
                .padding(.horizontal, 20)
                .padding(.top, 15)
                .padding(.bottom, 35)
            }
        }
        .navigationTitle("Add IOU")
        .navigationBarTitleDisplayMode(.inline)
        .toolbarColorScheme(.dark, for: .navigationBar)
        .toolbarBackground(.hidden, for: .navigationBar)
        .preferredColorScheme(.dark)
    }

    // MARK: Background

    private var backgroundView: some View {

        ZStack {

            LinearGradient(
                colors: [
                    Color(red: 0.055, green: 0.035, blue: 0.11),
                    Color(red: 0.08, green: 0.06, blue: 0.16),
                    Color(red: 0.035, green: 0.035, blue: 0.08)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )

            Circle()
                .fill(purple.opacity(0.18))
                .frame(width: 250, height: 250)
                .blur(radius: 100)
                .offset(x: 160, y: -350)
        }
        .ignoresSafeArea()
    }

    // MARK: Section Title

    private func sectionTitle(
        _ title: String,
        icon: String
    ) -> some View {

        HStack(spacing: 10) {

            Image(systemName: icon)
                .foregroundColor(lightPurple)

            Text(title)
                .font(.headline)
                .fontWeight(.bold)
                .foregroundColor(.white)
        }
    }

    // MARK: Field Label

    private func fieldLabel(_ title: String) -> some View {

        Text(title)
            .font(.caption2)
            .fontWeight(.bold)
            .tracking(1)
            .foregroundColor(.white.opacity(0.55))
    }

    // MARK: Transaction Type Card

    private func typeCard(
        title: String,
        subtitle: String,
        icon: String,
        type: IOUType,
        color: Color
    ) -> some View {

        let isSelected = selectedType == type

        return Button {

            selectedType = type

        } label: {

            VStack(alignment: .leading, spacing: 12) {

                HStack {

                    Image(systemName: icon)
                        .font(.title3)
                        .foregroundColor(color)
                        .frame(width: 42, height: 42)
                        .background(color.opacity(0.14))
                        .clipShape(RoundedRectangle(cornerRadius: 13))

                    Spacer()

                    if isSelected {

                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(lightPurple)
                    } else {

                        Circle()
                            .stroke(.white.opacity(0.3), lineWidth: 1)
                            .frame(width: 19, height: 19)
                    }
                }

                Text(title)
                    .font(.headline)
                    .foregroundColor(.white)

                Text(subtitle)
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.5))
            }
            .padding(14)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background {
                RoundedRectangle(cornerRadius: 18)
                    .fill(.ultraThinMaterial)
                    .environment(\.colorScheme, .dark)
                    .overlay {
                        RoundedRectangle(cornerRadius: 18)
                            .fill(
                                isSelected
                                ? purple.opacity(0.13)
                                : .white.opacity(0.025)
                            )
                    }
            }
            .clipShape(RoundedRectangle(cornerRadius: 18))
            .overlay {
                RoundedRectangle(cornerRadius: 18)
                    .stroke(
                        isSelected
                        ? purple.opacity(0.7)
                        : .white.opacity(0.10),
                        lineWidth: isSelected ? 1.5 : 1
                    )
            }
        }
        .buttonStyle(.plain)
    }

    // MARK: Glass Background

    private var glassBackground: some View {

        RoundedRectangle(cornerRadius: 15)
            .fill(.ultraThinMaterial)
            .environment(\.colorScheme, .dark)
            .overlay {
                RoundedRectangle(cornerRadius: 15)
                    .fill(.white.opacity(0.035))
            }
    }

    // MARK: Save IOU

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
