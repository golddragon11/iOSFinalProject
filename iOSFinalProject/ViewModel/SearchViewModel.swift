import SwiftUI

class SearchViewModel: ObservableObject {
    @Published var articles = [article]()
    @Published var status = String()
    @Published var totalResults = Int()
    
    func fetchSearch(keyword: String) {
        let urlString = "https://newsapi.org/v2/everything?q=" + keyword + "&apiKey=eac3e630243249dba444adeda61a0a39"
        if let url = URL(string: urlString) {
            URLSession.shared.dataTask(with: url) {(data, response, error) in
                let decoder = JSONDecoder()
                if let data = data, let headlineResults = try? decoder.decode(TopHeadlinesResult.self, from: data) {
                    DispatchQueue.main.async {
                        self.articles.removeAll()
                        self.status = headlineResults.status
                        self.totalResults = headlineResults.totalResults
                        self.articles = headlineResults.articles
                    }
                }
            }.resume()
        }
    }
    
    func fetchSearchSource(source: String) {
        let urlString = "https://newsapi.org/v2/everything?domains=" + source.lowercased() + "&apiKey=eac3e630243249dba444adeda61a0a39"
        if let url = URL(string: urlString) {
            URLSession.shared.dataTask(with: url) {(data, response, error) in
                let decoder = JSONDecoder()
                if let data = data, let headlineResults = try? decoder.decode(TopHeadlinesResult.self, from: data) {
                    DispatchQueue.main.async {
                        self.status = headlineResults.status
                        self.totalResults = headlineResults.totalResults
                        self.articles = headlineResults.articles
                    }
                }
            }.resume()
        }
    }
}
