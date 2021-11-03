//
//  OutfittersApp.swift
//  Outfitters
//
//  Created by Vincent Nguyen on 10/30/21.
//

import SwiftUI


@main
struct OutfittersApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    
    @StateObject var viewRouter = ViewRouter()
    var body: some Scene {
        WindowGroup {
            ContentView(viewRouter: viewRouter)
        }
    }
}
