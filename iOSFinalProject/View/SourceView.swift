import SwiftUI
import CoreData

struct SourceView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Source.name, ascending: true)],
        animation: .default)
    private var sources: FetchedResults<Source>
    
    @StateObject var searchViewModel = SearchViewModel()
    var sourceName: String
    
    var body: some View {
        VStack{
            List(searchViewModel.articles.indices, id: \.self, rowContent: { (index) in
                NewsPreview(article: searchViewModel.articles[index])
            })
        }
        .navigationTitle(sourceName)
        .onAppear(perform: {
            print(sourceName)
            searchViewModel.fetchSearch(keyword: sourceName)
        })
    }
}
