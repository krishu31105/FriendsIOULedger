
import SwiftUI

struct IOUListView: View {

    @ObservedObject var viewModel: IOUViewModel

    @State private var searchText = ""
    @State private var selectedFilter = "All"
    @State private var selectedStatus = "All"

    @State private var showDeleteConfirmation = false
    @State private var entryToDelete: IOUEntry?

    private let filters = ["All", "Lent", "Borrowed"]

    private let statuses = [
        "All",
        "Pending",
        "Partially Settled",
        "Settled"
    ]

    var filteredEntries: [IOUEntry] {

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

    var body: some View {

        NavigationStack {

            VStack(spacing: 15) {

                TextField("Search friend name", text: $searchText)
                    .padding()
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(10)
                    .padding(.horizontal)

                Picker("Type", selection: $selectedFilter) {

                    ForEach(filters, id: \.self) { filter in
                        Text(filter).tag(filter)
                    }
                }
                .pickerStyle(.segmented)
                .padding(.horizontal)

                Picker("Settlement Status", selection: $selectedStatus) {

                    ForEach(statuses, id: \.self) { status in
                        Text(status).tag(status)
                    }
                }
                .pickerStyle(.menu)
                .padding(.horizontal)

                if filteredEntries.isEmpty {

                    Spacer()

                    Image(systemName: "tray")
                        .font(.system(size: 45))
                        .foregroundColor(.gray)

                    Text("No IOU entries found")
                        .foregroundColor(.secondary)

                    Spacer()

                } else {

                    List {

                        ForEach(filteredEntries) { entry in

                            NavigationLink {

                                IOUDetailView(
                                    viewModel: viewModel,
                                    entry: entry
                                )

                            } label: {

                                VStack(alignment: .leading, spacing: 8) {

                                    HStack {

                                        Text(entry.friendName)
                                            .font(.headline)

                                        Spacer()

                                        Text(entry.type.rawValue)
                                            .font(.caption)
                                            .foregroundColor(
                                                entry.type == .lent ? .green : .orange
                                            )
                                    }

                                    HStack {

                                        Text(
                                            entry.amount,
                                            format: .currency(code: "INR")
                                        )
                                        .font(.title3)
                                        .fontWeight(.bold)

                                        Spacer()

                                        Text(entry.status.rawValue)
                                            .font(.caption)
                                            .padding(6)
                                            .background(Color.blue.opacity(0.1))
                                            .cornerRadius(6)
                                    }

                                    Text("Reason: \(entry.reason)")
                                        .font(.caption)
                                        .foregroundColor(.secondary)

                                    Text(
                                        "Pending: ₹\(String(format: "%.2f", entry.pendingAmount))"
                                    )
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                                }
                                .padding(.vertical, 6)
                            }
                        }
                        .onDelete { indexSet in

                            if let index = indexSet.first {
                                entryToDelete = filteredEntries[index]
                                showDeleteConfirmation = true
                            }
                        }
                    }
                    .listStyle(.plain)
                }
            }
            .navigationTitle("My IOUs")
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
    }
}

#Preview {
    IOUListView(viewModel: IOUViewModel())
}
