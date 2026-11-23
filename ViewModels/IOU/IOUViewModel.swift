
import Foundation
import Combine

class IOUViewModel: ObservableObject {

    private let storageKey = "savedIOUEntries"

    @Published var entries: [IOUEntry] = [] {
        didSet {
            saveEntries()
        }
    }

    init() {
        if let savedData = UserDefaults.standard.data(forKey: storageKey),
           let savedEntries = try? JSONDecoder().decode(
               [IOUEntry].self,
               from: savedData
           ) {

            entries = savedEntries

        } else {

            entries = [
                IOUEntry(
                    friendName: "Arun",
                    amount: 2000,
                    type: .lent,
                    date: Date(),
                    reason: "Movie tickets",
                    expectedReturnDate: Calendar.current.date(
                        byAdding: .day,
                        value: 7,
                        to: Date()
                    ) ?? Date(),
                    amountPaid: 500
                ),

                IOUEntry(
                    friendName: "Priya",
                    amount: 1500,
                    type: .borrowed,
                    date: Date(),
                    reason: "Shopping",
                    expectedReturnDate: Calendar.current.date(
                        byAdding: .day,
                        value: 5,
                        to: Date()
                    ) ?? Date(),
                    amountPaid: 0
                ),

                IOUEntry(
                    friendName: "Karthik",
                    amount: 3000,
                    type: .lent,
                    date: Date(),
                    reason: "College fees",
                    expectedReturnDate: Calendar.current.date(
                        byAdding: .day,
                        value: 10,
                        to: Date()
                    ) ?? Date(),
                    amountPaid: 1000
                )
            ]
        }
    }

    private func saveEntries() {
        do {
            let encodedData = try JSONEncoder().encode(entries)
            UserDefaults.standard.set(encodedData, forKey: storageKey)
        } catch {
            print("Error saving IOU entries: \(error.localizedDescription)")
        }
    }

    var totalToReceive: Double {
        entries
            .filter { $0.type == .lent }
            .reduce(0) { $0 + $1.pendingAmount }
    }

    var totalToPay: Double {
        entries
            .filter { $0.type == .borrowed }
            .reduce(0) { $0 + $1.pendingAmount }
    }

    var pendingEntriesCount: Int {
        entries.filter { $0.status != .settled }.count
    }

    var recentEntries: [IOUEntry] {
        Array(entries.sorted { $0.date > $1.date }.prefix(5))
    }

    func addEntry(_ entry: IOUEntry) {
        entries.append(entry)
    }

    func updateEntry(_ updatedEntry: IOUEntry) {
        if let index = entries.firstIndex(where: { $0.id == updatedEntry.id }) {
            entries[index] = updatedEntry
        }
    }

    func deleteEntry(_ entry: IOUEntry) {
        entries.removeAll { $0.id == entry.id }
    }
}
