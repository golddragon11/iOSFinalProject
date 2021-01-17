import SwiftUI
import UIKit
import FacebookLogin

struct EditUserInfo: View {
    @Binding var userData: User
    @State private var showSheet = false
    @State private var showImagePicker = false
    @State private var userImage = Image("")
    @State private var selectedImage = UIImage()
    let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    var body: some View {
        VStack {
            HStack {
                Button(action: {
                    if AccessToken.current != nil {
                        showSheet = true
                    } else {
                        showImagePicker = true
                    }
                })
                {
                    if let userImage = loadUserImage(fileName: userData.imageName) {
                        userImage
                            .resizable()
                            .frame(width: 80, height: 80, alignment: .center)
                            .clipShape(Circle())
                    } else {
                        Image(systemName: "person")
                            .resizable()
                            .frame(width: 80, height: 80)
                    }
                }
                .sheet(isPresented: $showImagePicker, content: {
                    ImagePickerController(selectedImage: $selectedImage, showImagePicker: $showImagePicker, user: $userData)
                })
                if AccessToken.current != nil {
                    Text(userData.name)
                        .font(.title)
                } else {
                    TextField("Username", text: $userData.name)
                        .padding()
                        .frame(width: 200)
                        .border(Color.black)
                }
            }
        }
        .navigationBarTitle(Text("Edit"))
        .actionSheet(isPresented: $showSheet, content: {
            ActionSheet(title: Text("Choose photo from..."), buttons: [.default(Text("Facebook profile")){
                if AccessToken.current != nil {
                    Profile.loadCurrentProfile { (profile, error) in
                        if let profile = profile {
                            let url = profile.imageURL(forMode: .square, size: CGSize(width: 300, height: 300))
                            if let data = try? Data(contentsOf: url!), let uiImage = UIImage(data: data) {
                                saveImage(image: uiImage)
                            }
                        }
                    }
                }
            }, .default(Text("iPhone")){
                showImagePicker = true
            }, .cancel()])
        })
    }
    
    private func loadUserImage(fileName: String) -> Image? {
        let fileURL = documentsDirectory.appendingPathComponent(fileName)
        let image = UIImage(contentsOfFile: fileURL.path)
        if image != nil {
            return Image(uiImage: image!)
        }
        return nil
    }
    
    func saveImage(image: UIImage) {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        var fileURL = documentsDirectory.appendingPathComponent(userData.imageName)
        do {
            try FileManager.default.removeItem(at: fileURL)
        } catch {
            
        }
        userData.imageName = UUID().uuidString
        fileURL = documentsDirectory.appendingPathComponent(userData.imageName)
        if let imageData = image.jpegData(compressionQuality: 1.0) {
            try? imageData.write(to: fileURL, options: .atomic)
        }
    }
}

//struct EditUserData_Previews: PreviewProvider {
//    static var previews: some View {
//        EditUserInfo()
//    }
//}
