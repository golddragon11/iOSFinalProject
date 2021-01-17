import SwiftUI
import UIKit

struct SearchView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @State private var searchText = ""
    @StateObject var searchViewModel = SearchViewModel()
    
    var body: some View {
        NavigationView {
            VStack {
                SearchBar(text: $searchText, searchViewModel: searchViewModel)
                List(searchViewModel.articles.indices, id: \.self, rowContent: { (index) in
                    NewsPreview(article: searchViewModel.articles[index])
                })
            }
            .navigationBarTitle("Search")
        }
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}
