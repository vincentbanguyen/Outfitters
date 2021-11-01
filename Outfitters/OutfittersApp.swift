//
//  OutfittersApp.swift
//  Outfitters
//
//  Created by Vincent Nguyen on 10/30/21.
//

import SwiftUI

@available(iOS 15.0, *)
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
