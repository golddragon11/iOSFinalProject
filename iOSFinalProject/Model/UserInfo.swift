import SwiftUI

struct User: Identifiable, Codable {
    var id = UUID()
    var name: String = ""
    var imageName: String = ""
}

class UserData: ObservableObject {
    @AppStorage ("user") var userData: Data?
    
    @Published var user = User() {
        didSet {
            let encoder = JSONEncoder()
            do {
                let data = try encoder.encode(user)
                userData = data
            } catch {
                
            }
        }
    }
    
    init() {
        if let userData = userData {
            let decoder = JSONDecoder()
            if let decodedData = try? decoder.decode(User.self, from: userData) {
                user = decodedData
            }
        }
    }
}
