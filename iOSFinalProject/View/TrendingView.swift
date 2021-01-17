import SwiftUI

struct TrendingView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @StateObject var trendingViewModel = TrendingViewModel()
    @EnvironmentObject var userData: UserData
    @State private var userImage = Image("")
    @State private var isShowing = false
    
    var body: some View {
        NavigationView {
            List(trendingViewModel.articles.indices, id: \.self, rowContent: { (index) in
                NewsPreview(article: trendingViewModel.articles[index])
                    .onAppear{
                        trendingViewModel.loadMoreContentIfNeeded(currentItem: trendingViewModel.articles[index])
                    }
            })
            .pullToRefresh(isShowing: $isShowing) {
                DispatchQueue.main.asyncAfter(deadline: .now()+1) {
                    trendingViewModel.fetchTrending()
                    self.isShowing = false
                }
            }
            .navigationBarItems(trailing: NavigationLink(
                                    destination: UserView(),
                                    label: {
                                        if let userImage = loadUserImage(fileName: userData.user.imageName) {
                                            userImage
                                                .resizable()
                                                .frame(width: 40, height: 40, alignment: .center)
                                                .clipShape(Circle())
                                        } else {
                                            Image(systemName: "person")
                                                .resizable()
                                                .frame(width: 30, height: 30)
                                        }
                                    }))
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("頭條新聞")
        }
    }
    private func loadUserImage(fileName: String) -> Image? {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let fileURL = documentsDirectory.appendingPathComponent(fileName)
        let image = UIImage(contentsOfFile: fileURL.path)
        if image != nil {
            return Image(uiImage: image!)
        }
        return nil
    }
}

//struct Trending_Previews: PreviewProvider {
//    static var previews: some View {
//        TrendingView()
//    }
//}
