
import SwiftUI

struct IOUListView: View {

    @ObservedObject var viewModel: IOUViewModel

    @State private var searchText = ""
    @State private var selectedFilter = "All"
    @State private var selectedStatus = "All"
    @State private var showDeleteConfirmation = false
    @State private var entryToDelete: IOUEntry?

    private let purple = Color(red: 0.58, green: 0.32, blue: 0.96)
    private let lightPurple = Color(red: 0.76, green: 0.58, blue: 1.0)

    private let filters = ["All", "Lent", "Borrowed"]

    private let statuses = [
        "All",
        "Pending",
        "Partially Settled",
        "Settled"
    ]

    // MARK: Filtered Entries

    private var filteredEntries: [IOUEntry] {

        viewModel.entries.filter { entry in

            let matchesSearch =
                searchText.isEmpty ||
                entry.friendName.localizedCaseInsensitiveContains(searchText)

            let matchesFilter =
                selectedFilter == "All" ||
                entry.type.rawValue == selectedFilter

            let matchesStatus =
                selectedStatus == "All" ||
                entry.status.rawValue == selectedStatus

            return matchesSearch && matchesFilter && matchesStatus
        }
    }

    // MARK: Body

    var body: some View {

        NavigationStack {

            ZStack {

                backgroundView

                ScrollView(showsIndicators: false) {

                    VStack(alignment: .leading, spacing: 23) {

                        // Header
                        headerSection

                        // Search
                        searchBar

                        // Lent and Borrowed Filters
                        filterSection

                        // Status Filter
                        statusFilter

                        // Transaction Count
                        HStack {
                            Text("Your Transactions")
                                .font(.title3)
                                .fontWeight(.bold)
                                .foregroundColor(.white)

                            Spacer()

                            Text("\(filteredEntries.count) entries")
                                .font(.caption)
                                .foregroundColor(lightPurple)
                        }

                        // Transaction List
                        if filteredEntries.isEmpty {

                            emptyState

                        } else {

                            LazyVStack(spacing: 13) {

                                ForEach(filteredEntries) { entry in

                                    NavigationLink {
                                        IOUDetailView(
                                            viewModel: viewModel,
                                            entry: entry
                                        )
                                    } label: {
                                        transactionCard(entry)
                                    }
                                    .buttonStyle(.plain)
                                    .swipeActions(
                                        edge: .trailing,
                                        allowsFullSwipe: false
                                    ) {
                                        Button(role: .destructive) {
                                            entryToDelete = entry
                                            showDeleteConfirmation = true
                                        } label: {
                                            Label("Delete", systemImage: "trash")
                                        }
                                    }
                                }
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                    .padding(.bottom, 30)
                }
            }
            .navigationTitle("My IOUs")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarColorScheme(.dark, for: .navigationBar)
            .toolbarBackground(.hidden, for: .navigationBar)
            .alert(
                "Delete IOU?",
                isPresented: $showDeleteConfirmation
            ) {

                Button("Delete", role: .destructive) {

                    if let entry = entryToDelete {
                        viewModel.deleteEntry(entry)
                    }

                    entryToDelete = nil
                }

                Button("Cancel", role: .cancel) {
                    entryToDelete = nil
                }

            } message: {

                Text("Are you sure you want to delete this IOU entry?")
            }
        }
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

    // MARK: Header

    private var headerSection: some View {

        VStack(alignment: .leading, spacing: 7) {

            Text("YOUR FINANCES")
                .font(.caption)
                .fontWeight(.bold)
                .tracking(2)
                .foregroundColor(lightPurple)

            Text("All Your IOUs")
                .font(.system(size: 28, weight: .bold))
                .foregroundColor(.white)

            Text("Keep track of money between friends.")
                .font(.subheadline)
                .foregroundColor(.white.opacity(0.5))
        }
    }

    // MARK: Search Bar

    private var searchBar: some View {

        HStack(spacing: 12) {

            Image(systemName: "magnifyingglass")
                .foregroundColor(lightPurple)
                .font(.headline)

            TextField("Search friend name...", text: $searchText)
                .foregroundColor(.white)
                .tint(lightPurple)

            if !searchText.isEmpty {

                Button {
                    searchText = ""
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.gray)
                }
            }
        }
        .padding()
        .background(glassBackground)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .overlay {
            RoundedRectangle(cornerRadius: 16)
                .stroke(.white.opacity(0.10), lineWidth: 1)
        }
    }

    // MARK: Type Filters

    private var filterSection: some View {

        HStack(spacing: 10) {

            ForEach(filters, id: \.self) { filter in

                Button {
                    selectedFilter = filter
                } label: {

                    Text(filter)
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 13)
                        .background {

                            if selectedFilter == filter {

                                LinearGradient(
                                    colors: [purple, Color.purple],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )

                            } else {

                                Color.white.opacity(0.06)
                            }
                        }
                        .foregroundColor(
                            selectedFilter == filter
                            ? .white
                            : .white.opacity(0.65)
                        )
                        .clipShape(RoundedRectangle(cornerRadius: 13))
                        .overlay {
                            RoundedRectangle(cornerRadius: 13)
                                .stroke(
                                    .white.opacity(
                                        selectedFilter == filter ? 0.2 : 0.08
                                    ),
                                    lineWidth: 1
                                )
                        }
                }
                .buttonStyle(.plain)
            }
        }
    }

    // MARK: Status Filter

    private var statusFilter: some View {

        Menu {

            ForEach(statuses, id: \.self) { status in

                Button {
                    selectedStatus = status
                } label: {

                    if selectedStatus == status {

                        Label(status, systemImage: "checkmark")

                    } else {

                        Text(status)
                    }
                }
            }

        } label: {

            HStack(spacing: 10) {

                Image(systemName: "slider.horizontal.3")
                    .foregroundColor(lightPurple)

                Text("Status:")
                    .foregroundColor(.white.opacity(0.55))

                Text(selectedStatus)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)

                Spacer()

                Image(systemName: "chevron.down")
                    .font(.caption)
                    .foregroundColor(lightPurple)
            }
            .padding(14)
            .background(glassBackground)
            .clipShape(RoundedRectangle(cornerRadius: 14))
            .overlay {
                RoundedRectangle(cornerRadius: 14)
                    .stroke(.white.opacity(0.10), lineWidth: 1)
            }
        }
    }

    // MARK: Transaction Card

    private func transactionCard(_ entry: IOUEntry) -> some View {

        let isLent = entry.type == .lent
        let transactionColor: Color = isLent ? .green : .orange

        return VStack(alignment: .leading, spacing: 15) {

            HStack(spacing: 13) {

                Image(systemName: isLent ? "arrow.up.right" : "arrow.down.left")
                    .font(.headline)
                    .foregroundColor(transactionColor)
                    .frame(width: 46, height: 46)
                    .background(transactionColor.opacity(0.14))
                    .clipShape(RoundedRectangle(cornerRadius: 14))

                VStack(alignment: .leading, spacing: 5) {

                    Text(entry.friendName)
                        .font(.headline)
                        .foregroundColor(.white)

                    Text(entry.type.rawValue)
                        .font(.caption)
                        .foregroundColor(transactionColor)
                }

                Spacer()

                VStack(alignment: .trailing, spacing: 5) {

                    Text(
                        entry.amount,
                        format: .currency(code: "INR")
                    )
                    .font(.headline)
                    .foregroundColor(.white)

                    Text("Total Amount")
                        .font(.system(size: 10))
                        .foregroundColor(.white.opacity(0.4))
                }
            }

            Rectangle()
                .fill(.white.opacity(0.10))
                .frame(height: 1)

            HStack {

                VStack(alignment: .leading, spacing: 5) {

                    Text("REASON")
                        .font(.system(size: 9, weight: .bold))
                        .tracking(1)
                        .foregroundColor(.white.opacity(0.4))

                    Text(entry.reason)
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.8))
                        .lineLimit(1)
                }

                Spacer()

                VStack(alignment: .trailing, spacing: 5) {

                    Text("PENDING")
                        .font(.system(size: 9, weight: .bold))
                        .tracking(1)
                        .foregroundColor(.white.opacity(0.4))

                    Text(
                        entry.pendingAmount,
                        format: .currency(code: "INR")
                    )
                    .font(.subheadline)
                    .fontWeight(.bold)
                    .foregroundColor(lightPurple)
                }
            }

            HStack {

                Text(entry.status.rawValue)
                    .font(.caption2)
                    .fontWeight(.semibold)
                    .foregroundColor(statusColor(entry.status.rawValue))
                    .padding(.horizontal, 11)
                    .padding(.vertical, 6)
                    .background(
                        statusColor(entry.status.rawValue).opacity(0.13)
                    )
                    .clipShape(Capsule())

                Spacer()

                HStack(spacing: 5) {

                    Text("View Details")
                        .font(.caption)
                        .foregroundColor(lightPurple)

                    Image(systemName: "chevron.right")
                        .font(.system(size: 9, weight: .bold))
                        .foregroundColor(lightPurple)
                }
            }
        }
        .padding(17)
        .background(glassBackground)
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .overlay {
            RoundedRectangle(cornerRadius: 20)
                .stroke(.white.opacity(0.10), lineWidth: 1)
        }
    }

    // MARK: Status Colors

    private func statusColor(_ status: String) -> Color {

        switch status {

        case "Settled":
            return .green

        case "Partially Settled":
            return .orange

        case "Pending":
            return lightPurple

        default:
            return .gray
        }
    }

    // MARK: Empty State

    private var emptyState: some View {

        VStack(spacing: 15) {

            Image(systemName: "tray")
                .font(.system(size: 45))
                .foregroundColor(lightPurple)

            Text("No IOU Entries Found")
                .font(.headline)
                .foregroundColor(.white)

            Text(
                searchText.isEmpty
                ? "Your transactions will appear here."
                : "Try searching with another friend name."
            )
            .font(.caption)
            .foregroundColor(.white.opacity(0.5))
            .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 45)
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
    IOUListView(viewModel: IOUViewModel())
}
