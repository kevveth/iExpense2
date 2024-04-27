//
//  iExpense2App.swift
//  iExpense2
//
//  Created by Kenneth Oliver Rathbun on 4/25/24.
//

import SwiftUI
import SwiftData

@main
struct iExpense2App: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: ExpenseItem.self)
    }
}
