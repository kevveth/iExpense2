//
//  ExpenseItem.swift
//  iExpense2
//
//  Created by Kenneth Oliver Rathbun on 4/25/24.
//

import Foundation
import SwiftData

@Model
class ExpenseItem: Hashable {
    var id: UUID
    var name: String
    var type: String
    var amount: Decimal
    var currency: String
    
    init(id: UUID = UUID(), name: String, type: String = "Personal", amount: Decimal, currency: String = "USD") {
        self.id = id
        self.name = name
        self.type = type
        self.amount = amount
        self.currency = currency
    }
}

