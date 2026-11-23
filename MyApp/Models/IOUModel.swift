import Foundation

enum IOUType: String, CaseIterable, Codable {
    case lent = "Lent"
    case borrowed = "Borrowed"
}

enum SettlementStatus: String, Codable {
    case pending = "Pending"
    case partiallySettled = "Partially Settled"
    case settled = "Settled"
}

struct IOUEntry: Identifiable, Codable {

    var id = UUID()

    var friendName: String
    var amount: Double
    var type: IOUType

    var date: Date
    var reason: String
    var expectedReturnDate: Date

    var amountPaid: Double

    var pendingAmount: Double {
        max(0, amount - amountPaid)
    }

    var status: SettlementStatus {
        if amountPaid <= 0 {
            return .pending
        } else if amountPaid >= amount {
            return .settled
        } else {
            return .partiallySettled
        }
    }
}
