//
//  ContentView.swift
//  Devote
//
//  Created by Bora Gündoğu on 14.01.2024.
//

import SwiftUI
import CoreData

struct ContentView: View {
    //MARK: - Property
    @State var task: String = ""
    private var isButtonDisabled: Bool {
        task.isEmpty
    }
    
    //MARK: - Fetching Data
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Item.timestamp, ascending: true)],
        animation: .default)
    private var items: FetchedResults<Item>
    //MARK: - Funtion
    
    private func addItem() {
        withAnimation {
            let newItem = Item(context: viewContext)
            newItem.timestamp = Date()
            newItem.task = task
            newItem.completion = false
            newItem.id = UUID()
            
            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
            
            task = ""
            hideKeyboard()
        }
    }
    
    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { items[$0] }.forEach(viewContext.delete)
            
            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
    //MARK: - Body
    
    var body: some View {
        NavigationView {
            VStack {
                
                VStack(spacing: 16) {
                    TextField("New Task", text: $task)
                        .padding()
                        .background(
                            Color(UIColor.systemGray6)
                        )
                        .cornerRadius(10)
                    
                    Button {
                        addItem()
                    } label: {
                        Spacer()
                        Text("Save")
                        Spacer()
                    }
                    .disabled(isButtonDisabled)
                    .padding()
                    .font(.headline)
                    .foregroundStyle(.white)
                    .background(isButtonDisabled ? Color.gray : Color.pink)
                    .cornerRadius(10)

                }//Vstack
                .padding()
                
                List {
                    ForEach(items) { item in
                        VStack(alignment: .leading) {
                            Text(item.task ?? "")
                                .font(.headline)
                                .fontWeight(.bold)
                            Text("Item at \(item.timestamp!, formatter: itemFormatter)")
                            .font(.footnote)
                            .foregroundStyle(.gray)
                        }
                    }
                    .onDelete(perform: deleteItems)
                }
            }//VStack
            .navigationTitle("Daily Tasks")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    EditButton()
                }
            }//Toolbar
            Text("Select an item")
        }
    }
}

//MARK: - Preview

#Preview {
    ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
