//
//  iOSFinalProjectApp.swift
//  iOSFinalProject
//
//  Created by Steve Shen on 2020/12/16.
//

import SwiftUI

@main
struct iOSFinalProjectApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
