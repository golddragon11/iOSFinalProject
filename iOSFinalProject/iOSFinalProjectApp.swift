import SwiftUI
import FacebookCore

@main
struct iOSFinalProjectApp: App {
    let persistenceController = PersistenceController.shared
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @ObservedObject var userData = UserData()

    var body: some Scene {
        WindowGroup {
//            ContentView()
//                .environment(\.managedObjectContext, persistenceController.container.viewContext)
            Homepage()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .environmentObject(userData)
                .onOpenURL(perform: { url in
                    ApplicationDelegate.shared.application(UIApplication.shared, open: url, sourceApplication: nil, annotation: UIApplication.OpenURLOptionsKey.annotation)
                })
        }
    }
}
