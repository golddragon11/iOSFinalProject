import SwiftUI
import Combine

class TrendingViewModel: ObservableObject {
    @Published var articles = [article]()
    @Published var status = String()
    @Published var totalResults = Int()
    @Published var isLoadingPage = false
    private var currentPage = 1
    private var canLoadMorePages = true
    
    func fetchTrending() -> Void {
        let urlString = "https://newsapi.org/v2/top-headlines?country=tw&apiKey=eac3e630243249dba444adeda61a0a39"
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
    
    init() {
        loadMoreContent()
    }
    
    private func loadMoreContent() {
        guard !isLoadingPage && canLoadMorePages else {
            return
        }
        isLoadingPage = true
        let url = URL(string: "https://newsapi.org/v2/top-headlines?country=tw&pageSize=10&page=" + String(currentPage) + "&apiKey=eac3e630243249dba444adeda61a0a39")!
        URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: TopHeadlinesResult.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .handleEvents(receiveOutput: { response in
                self.isLoadingPage = false
                self.currentPage += 1
            })
            .map({response in
                return self.articles + response.articles
            })
            .catch({ _ in Just(self.articles) })
            .assign(to: &$articles)
    }
    
    func loadMoreContentIfNeeded(currentItem item: article?) {
        guard let item = item else {
            loadMoreContent()
            return
        }
        
        let thresholdIndex = articles.index(articles.endIndex, offsetBy: -5)
        if articles.firstIndex(where: { $0.title == item.title}) == thresholdIndex {
            loadMoreContent()
        }
    }
}
