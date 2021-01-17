import SwiftUI

struct NetworkImage: View {
    var url: URL {
        didSet {
            download()
        }
    }
    @State private var image = Image(systemName: "photo")
    @State private var downloadImageOk = false
    var body: some View {
        image
            .resizable()
            .scaledToFit()
            .frame(width: 100)
//            .padding(.trailing)
            .onAppear {
                if downloadImageOk == false {
                    download()
                }
            }
    }
    func download() {
        if let data = try? Data(contentsOf: url), let uiImage = UIImage(data: data) {
            image = Image(uiImage: uiImage)
            downloadImageOk = true
        }
    }
}
