//
//  TodoView.swift
//  ToDos
//
//  Created by Philipp Kuecuekyan on 9/27/24.
//

import SwiftUI
import SwiftData

/// Main view for ToDos and entry point
struct TodoView: View {
    
    // MARK: - Properties
    
    @Environment(\.modelContext) private var modelContext
    @Environment(\.shouldImportContent) private var shouldImportContent
    
    @State private var selectedFilter: TodoFilter = .all
    
    private var importer = TodoImporter()
    
    // MARK: - Main view
    
    var body: some View {
        NavigationView {
            VStack {
                pickerView()
                ListView(filter: selectedFilter)
            }
            .navigationTitle("To Dos")
            .toolbar(content: {
                EditButton()
                    .accessibilityIdentifier("toDoEditButton")
            })
        }
        .onAppear {
            if shouldImportContent {
                importer.importToDos(
                    forUserWithID: 3,
                    into: modelContext,
                    maxCount: 5
                )
            }
        }
    }
    
    // MARK: - View builder (private)
    
    private func pickerView() -> some View {
        Picker(
            "Todo Filter",
            selection: $selectedFilter
        ) {
            ForEach(TodoFilter.allCases, id: \.self) { filter in
                Text(filter.rawValue).tag(filter)
            }
        }
        .accessibilityIdentifier("toDoPicker")
        .accessibilityLabel("Picker to filter list by completed and open to-dos")
        .padding(
            [.leading, .trailing], 20
        )
        .pickerStyle(
            SegmentedPickerStyle()
        )
    }
        
 }

// MARK: - Preview

#Preview {
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: Todo.self, configurations: config)
        return TodoView()
            .modelContainer(container)
            .environment(\.shouldImportContent, false)   
    } catch {
        fatalError("Failed to create model container: \(error.localizedDescription)")
    }
}
