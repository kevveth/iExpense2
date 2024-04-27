//
//  AddExpenseView.swift
//  iExpense2
//
//  Created by Kenneth Oliver Rathbun on 4/25/24.
//

import SwiftUI
import SwiftData

struct AddExpenseView: View {
    @State private var name: String = ""
    @State private var type: String = "Personal"
    @State private var amount: Decimal = 0.0
    @State private var currency: String = "USD"
    
    @Environment(\.modelContext) var modelContext
    @Environment(\.dismiss) var dismiss
    
    let ExpenseTypes: [String] = [
        "Personal",
        "Business",
        "Grocery"
    ]
    
    let currencyCodes = ["USD", "EUR", "GBP", "JPY", "CAD", "AUD"]
    
    var validExpense: Bool {
        let trimmedName = name.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedType = type.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if trimmedName.isEmpty || trimmedType.isEmpty || amount <= 0 {
            return false
        }
        
        return true
    }
    
    var body: some View {
        NavigationStack {
            Form {
                TextField("Name", text: $name)
                
                Picker("Type", selection: $type) {
                    ForEach(ExpenseTypes.indices) { index in
                        Text(ExpenseTypes[index])
                            .tag(ExpenseTypes[index])
                    }
                }
                
                HStack {
                    TextField("", value: $amount, format: .number.precision(.fractionLength(2)))
                        .keyboardType(.decimalPad)
                    Picker("", selection: $currency) {
                        ForEach(currencyCodes, id: \.self) { code in
                            Text("\(code)")
                        }
                    }
                }
                
                Text(amount, format: .currency(code: currency))
                
                Button("Save") {
                    let item = ExpenseItem(name: name, type: type, amount: amount, currency: currency)
                    modelContext.insert(item)
                    dismiss()
                }
                .disabled(validExpense == false)
            }
            .navigationTitle("Add an Expense")
        }
    }
}

#Preview {
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: ExpenseItem.self, configurations: config)
        return AddExpenseView()
            .modelContainer(container)
    } catch {
        return Text("Failed: \(error.localizedDescription)")
    }
}
