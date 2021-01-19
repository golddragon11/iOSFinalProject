import SwiftUI
import CoreData
import UIKit

enum ActiveSheet {
    case share, safari
}

struct NewsPreview: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Article.timestamp, ascending: true)],
        animation: .default)
    private var articles: FetchedResults<Article>
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Source.name, ascending: true)],
        animation: .default)
    private var sources: FetchedResults<Source>
    
    @State private var showSheet = false
    @State private var activeSheet: ActiveSheet = .safari
    @State private var showWebPage = false
    @State private var showShareView = false
    let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    var article: article
    var body: some View {
        HStack {
            NetworkImage(url: URL(string: article.urlToImage ?? "https://www.google.com/url?sa=i&url=https%3A%2F%2Fuxwing.com%2Fimage-not-found-icon%2F&psig=AOvVaw1kK9peNfJ3BpXwn4SRSLbT&ust=1611109442272000&source=images&cd=vfe&ved=0CAIQjRxqFwoTCKi9ssP4pu4CFQAAAAAdAAAAABAD")!)
            VStack {
                Text(article.title)
                    .font(.title2)
                Text(article.description ?? "")
                    .font(.caption2)
                    .frame(width: 210)
                HStack {
                    Spacer()
                    Image(article.source.name)
                        .resizable()
                        .scaledToFit()
                        .frame(height: 20)
                    Text(article.source.name)
                        .font(.footnote)
                }
            }
        }
        .contextMenu {
            Button(action: {
                addArticle(article: article)
            }) {
                Image(systemName: "bookmark")
                Text("Save article")
            }
            Button(action: {
                addSource(source: article.source.name)
            }) {
                Image(systemName: "plus.app")
                Text("Subscribe to source")
            }
            Button(action: {
                activeSheet = .share
                showSheet.toggle()
            }) {
                Image(systemName: "square.and.arrow.up")
                Text("Share")
            }
        }
        .onTapGesture(count: 2) {
            activeSheet = .share
            showSheet.toggle()
        }
        .onTapGesture(count: 1) {
            activeSheet = .safari
            showSheet.toggle()
        }
        .sheet(isPresented: $showSheet, content: {
            if self.activeSheet == .safari {
                SafariView(url: URL(string: article.url)!)
            } else {
                ShareView(url: URL(string: article.url)!)
            }
        })
        .frame(height: 150)
    }
    
    func addArticle(article: article) {
        withAnimation {
            let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest<NSFetchRequestResult>(entityName: "Article")
            fetchRequest.predicate = NSPredicate(format: "url == %@", article.url)

            do {
                let results = try viewContext.fetch(fetchRequest)
                if results.count == 0 {
                    let newArticle = Article(context: viewContext)
                    newArticle.timestamp = Date()
                    newArticle.url = article.url
                    newArticle.source = article.source.name
                    newArticle.title = article.title
                    if let data = try? Data(contentsOf: URL(string: article.urlToImage!)!), let uiImage = UIImage(data: data) {
                        saveImage(image: uiImage, article: newArticle)
                    }
                    
                    try viewContext.save()
                    print("Success on save\n")
                } else {
                    print("Already exist\n")
                }
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
    
    func addSource(source: String) {
        withAnimation {
            let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest<NSFetchRequestResult>(entityName: "Source")
            fetchRequest.predicate = NSPredicate(format: "name == %@", source)

            do {
                let results = try viewContext.fetch(fetchRequest)
                if results.count == 0 {
                    let newSource = Source(context: viewContext)
                    newSource.name = source
                    
                    try viewContext.save()
                    print("Success on save\n")
                } else {
                    print("Already exist\n")
                }
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
    
    func saveImage(image: UIImage, article: Article) {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        article.urlToImage = UUID().uuidString
        let fileURL = documentsDirectory.appendingPathComponent(article.urlToImage!)
        print(article.urlToImage!)
        if let imageData = image.jpegData(compressionQuality: 1.0) {
            try? imageData.write(to: fileURL, options: .atomic)
        }
    }
}

struct NewsPreviewFromCoreData: View {
    @State private var showWebPage = false
    let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    var article: Article
    var body: some View {
        Button(action: {
            showWebPage = true
            print(article.urlToImage!)
        }){
            HStack {
                Image(uiImage: UIImage(contentsOfFile: documentsDirectory.appendingPathComponent(article.urlToImage!).path)!)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100)
                VStack {
                    Text(article.title!)
                        .font(.title2)
                    HStack {
                        Spacer()
                        Image(article.source!)
                            .resizable()
                            .scaledToFit()
                            .frame(height: 20)
                        Text(article.source!)
                            .font(.footnote)
                    }
                }
            }
        }
        .sheet(isPresented: $showWebPage, content: {
            SafariView(url: URL(string: article.url!)!)
        })
        .frame(height: 150)
    }
}

//struct NewsPreview_Previews: PreviewProvider {
//    static var previews: some View {
//        NewsPreview(article: article(source: source(name: "Newtalk.tw"), author: "Garrick Hileman", title: "Governments Will Start to Hodl Bitcoin in 2021", description: "Crypto assets like bitcoin and ether are not going away, they are becoming integral to our financial and political lives.", url: "https://www.coindesk.com/?p=559687", urlToImage: "https://static.coindesk.com/wp-content/uploads/2020/12/garrick-hileman-1200x628.png", publishedAt: "2020-12-31T15:00:43Z", content: "Reflecting on 2020, I struggle to think of another year in recent decades with both so many all-time highs and all-time lows.\r\nFrom the COVID-19 pandemic raging across the global population to record… [+7545 chars]"))
//            .preferredColorScheme(.dark)
//    }
//}
