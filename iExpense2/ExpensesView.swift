//
//  ExpensesView.swift
//  iExpense2
//
//  Created by Kenneth Oliver Rathbun on 4/25/24.
//

import SwiftUI
import SwiftData

enum ExpenseFilter: String, CaseIterable, Codable {
    case all = "All Expenses"
    case personal = "Personal"
    case business = "Business"
    case grocery = "Grocery"
    
    var predicate: Predicate<ExpenseItem> {
        switch self {
        case .all:
            return #Predicate<ExpenseItem> { _ in true }
        case .personal:
            return #Predicate<ExpenseItem> { item in item.type == "Personal" }
        case .business:
            return #Predicate<ExpenseItem> { item in item.type == "Business" }
        case .grocery:
            return #Predicate<ExpenseItem> { item in item.type == "Grocery" }
        }
    }
}

struct ExpensesView: View {
    @Environment(\.modelContext) var modelContext
    @Query var expenses: [ExpenseItem]
    
    init(sortOrder: [SortDescriptor<ExpenseItem>], filter: ExpenseFilter = .all) {
        var predicate: Predicate<ExpenseItem>?
        
        switch filter {
        case .all:
            predicate = ExpenseFilter.all.predicate
        case .personal:
            predicate = ExpenseFilter.personal.predicate
        case .business:
            predicate = ExpenseFilter.business.predicate
        case .grocery:
            predicate = ExpenseFilter.grocery.predicate
        }
        
        _expenses = Query(
            filter: predicate ?? ExpenseFilter.all.predicate,
            sort: sortOrder)
    }
    
    var body: some View {
        List {
            ForEach(expenses) { item in
                HStack {
                    VStack(alignment: .leading) {
                        Text(item.name)
                            .font(.headline)
                        Text(item.type)
                    }
                    Spacer()
                    Text(item.amount, format: .currency(code: item.currency))
                        .foregroundStyle(
                            item.amount < 10 ? .green :
                                item.amount < 100 ? .orange : .red
                        )
                }
            }
            .onDelete(perform: deleteExpenses)
            
            Button("Add Sample Data") {
                let samplePersonalExpense = ExpenseItem(name: "Coffee", amount: 5.0)
                let sampleBusinessExpense = ExpenseItem(name: "Macbook Air", type: "Business", amount: 900.0)
                
                modelContext.insert(samplePersonalExpense)
                modelContext.insert(sampleBusinessExpense)
            }
        }
    }
    
    func deleteExpenses(at offsets: IndexSet) {
        for offset in offsets {
            let expense = expenses[offset]
            modelContext.delete(expense)
        }
    }
}

#Preview {
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: ExpenseItem.self, configurations: config)
        
        return ExpensesView(sortOrder: [])
            .modelContainer(container)
    } catch {
        return Text("Failed to make a preview: \(error.localizedDescription)")
    }
    
}
