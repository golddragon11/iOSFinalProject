import SwiftUI
import CoreData

struct ForLaterView: View {
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Article.timestamp, ascending: true)],
        animation: .default)
    private var articles: FetchedResults<Article>
    
    let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    var body: some View {
        NavigationView {
            List {
                ForEach(articles) { article in
                    NewsPreviewFromCoreData(article: article)
                }
                .onDelete(perform: deleteArticle)
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing)  {
                    HStack {
                        EditButton()
                    }
                }
            }
            .navigationTitle("For Later")
        }
    }
    
    private func deleteArticle(offsets: IndexSet) {
        withAnimation {
            let fileURL = documentsDirectory.appendingPathComponent(offsets.map {articles[$0].urlToImage!}[0])
            do {
                try FileManager.default.removeItem(at: fileURL)
            } catch {

            }
            offsets.map { articles[$0] }.forEach(viewContext.delete)

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

private let articleFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()

struct preview: PreviewProvider {
    static var previews: some View {
        ForLaterView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
