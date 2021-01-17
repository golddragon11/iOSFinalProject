import SwiftUI
import FacebookLogin

struct UserView: View {
    @EnvironmentObject var userData: UserData
    @State private var showEditView = false
    @State private var confirmLogout = false
    @State private var angle: Double = 0.0
    @State private var test = true
    let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    var body: some View {
        NavigationLink(destination: EditUserInfo(userData: $userData.user), isActive: $showEditView, label: {})
        VStack {
            HStack {
                if let userImage = loadImage(fileName: userData.user.imageName) {
                    Image(uiImage: userImage)
                        .resizable()
                        .frame(width: 80, height: 80, alignment: .center)
                        .clipShape(Circle())
                } else {
                    Image(systemName: "person")
                        .resizable()
                        .frame(width: 80, height: 80, alignment: .center)
                }
                Text(userData.user.name)
                    .font(.title)
            }
            if AccessToken.current == nil {
                Button(action: {
                    let manager = LoginManager()
                    manager.logIn{ (result) in
                        if case LoginResult.success(granted: _, declined: _, token: _) = result {
                            print("Login Successful\n")
                            if AccessToken.current != nil {
                                Profile.loadCurrentProfile { (profile, error) in
                                    if let profile = profile {
                                        userData.user.name = profile.name ?? userData.user.name
                                    }
                                }
                            }
                        } else {
                            print("Login Failed\n")
                        }
                    }
                }) {
                    Image("Login")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 50)
                }
            } else {
                Button(action: {
                    let manager = LoginManager()
                    manager.logOut()
                    self.confirmLogout.toggle()
                }) {
                    Text("Logout")
                }
            }
        }
        .navigationBarItems(trailing: Button(action: { showEditView = true }, label: { Text("Edit") }))
        .alert(isPresented: $confirmLogout) { () -> Alert in
            return Alert(title: Text("Logout Successful"))
        }
    }
    
    private func loadImage(fileName: String) -> UIImage? {
        let fileURL = documentsDirectory.appendingPathComponent(fileName)
        do {
            let imageData = try Data(contentsOf: fileURL)
            return UIImage(data: imageData)
        } catch {
            
        }
        return nil
    }
}
