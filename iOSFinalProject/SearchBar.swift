import Foundation
import UIKit
import SwiftUI

struct SearchBar: UIViewRepresentable {

    @Binding var text: String
    @ObservedObject var searchViewModel: SearchViewModel

    class Coordinator: NSObject, UISearchBarDelegate {

        @Binding var text: String
        @ObservedObject var searchViewModel: SearchViewModel

        init(text: Binding<String>, searchViewModel: ObservedObject<SearchViewModel>) {
            _text = text
            _searchViewModel = searchViewModel
        }

        func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
            text = searchText
        }
        
        func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
            searchBar.resignFirstResponder()
            searchViewModel.articles.removeAll()
            searchViewModel.fetchSearch(keyword: text)
        }
        
        func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
            searchBar.resignFirstResponder()
        }
    }

    func makeCoordinator() -> SearchBar.Coordinator {
        return Coordinator(text: $text, searchViewModel: _searchViewModel)
    }

    func makeUIView(context: UIViewRepresentableContext<SearchBar>) -> UISearchBar {
        let searchBar = UISearchBar(frame: .zero)
        searchBar.delegate = context.coordinator
        searchBar.searchBarStyle = .minimal
        searchBar.placeholder = "Search"
        return searchBar
    }

    func updateUIView(_ uiView: UISearchBar, context: UIViewRepresentableContext<SearchBar>) {
        uiView.text = text
    }
}
