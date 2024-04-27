//
//  ContentView.swift
//  iExpense2
//
//  Created by Kenneth Oliver Rathbun on 4/25/24.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) var modelContext
    
    // Sort by add date by default (system default)
    @State private var sortOrder = [SortDescriptor<ExpenseItem>]()
    @State private var filter: ExpenseFilter = .all
    
    
    var body: some View {
        NavigationStack {
            ExpensesView(sortOrder: sortOrder, filter: filter)
                .navigationTitle("iExpense2")
                .toolbar {
                    ToolbarItem {
                        NavigationLink {
                            AddExpenseView()
                        } label: {
                            Label("Add Expense", systemImage: "plus")
                        }
                    }
                    
                    ToolbarItem {
                        Menu("Filter", systemImage: "line.3.horizontal.decrease.circle") {
                            Picker("Filter", selection: $filter) {
                                ForEach(ExpenseFilter.allCases, id: \.self) { filter in
                                    Text("\(filter.rawValue)")
                                        .tag(filter)
                                }
                            }
                        }
                    }
                    
                    ToolbarItem {
                        Menu("Sort", systemImage: "arrow.up.arrow.down") {
                            Picker("Sort", selection: $sortOrder) {
                                Text("None")
                                    .tag([
                                        SortDescriptor<ExpenseItem>
                                    ]())
                                
                                Text("Name")
                                    .tag([
                                        SortDescriptor(\ExpenseItem.name)
                                    ])
                                
                                Text("Type")
                                    .tag([
                                        SortDescriptor(\ExpenseItem.type)
                                    ])
                                
                                Text("Amount")
                                    .tag([
                                        SortDescriptor(\ExpenseItem.amount)
                                    ])
                            }
                        }
                    }
                }
        }
    }
}

#Preview {
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: ExpenseItem.self, configurations: config)
        
        return ContentView()
            .modelContainer(container)
    } catch {
        return Text("Failed to create preview: \(error.localizedDescription)")
    }
}
