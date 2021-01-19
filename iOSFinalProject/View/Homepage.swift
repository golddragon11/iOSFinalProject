import SwiftUI

// APIKey = eac3e630243249dba444adeda61a0a39
// https://newsapi.org/v2/top-headlines?&apiKey=eac3e630243249dba444adeda61a0a39

struct Homepage: View {
    @Environment(\.managedObjectContext) private var viewContext
    @EnvironmentObject var userData: UserData
    
    @State private var selectedImage = UIImage()
    var body: some View {
        ZStack {
            EmitterLayerView()
            TabView {
                TrendingView()
    //            Text(documentsDirectory.absoluteString)
                    .tabItem {
                        Text("Explore")
                        Image(systemName: "safari")
                    }
                SearchView()
                    .tabItem {
                        Text("Search")
                        Image(systemName: "magnifyingglass")
                    }
                ForLaterView()
                    .tabItem {
                        Text("For Later")
                        Image(systemName: "tray.full")
                    }
                SourceHomeView()
                    .tabItem {
                        Text("Subscribed")
                        Image(systemName: "link")
                    }
    //            ContentView()
    //                .tabItem { Text("Text") }
            }
        }
    }
}

struct homepage_Preview: PreviewProvider {
    static var previews: some View {
        Homepage()
    }
}
