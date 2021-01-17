import SwiftUI
import CoreData

struct SourceHomeView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Source.name, ascending: true)],
        animation: .default)
    private var sources: FetchedResults<Source>
    @State private var showSourceView = false
    
    var body: some View {
        NavigationView {
            List {
                ForEach(sources) { source in
                    NavigationLink(destination: SourceView(sourceName: source.name!)) {
                        HStack {
                            Image(source.name!)
                                .resizable()
                                .scaledToFit()
                                .frame(height: 100)
                            Text(source.name!)
                        }
                    }
                }
                .onDelete(perform: deleteSource)
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing)  {
                    HStack {
                        EditButton()
                    }
                }
            }
            .navigationTitle("My Subscription")
        }
    }
    
    func deleteSource(offsets: IndexSet) {
        withAnimation {
            offsets.map { sources[$0] }.forEach(viewContext.delete)

            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}
