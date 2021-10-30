//
//  OutfittersApp.swift
//  Outfitters
//
//  Created by Vincent Nguyen on 10/30/21.
//

import SwiftUI
import Amplify
import AWSDataStorePlugin
@main
struct OutfittersApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
//    init() {
//        configureAmplify()
//    }
    @StateObject var viewRouter = ViewRouter()
    var body: some Scene {
        WindowGroup {
            ContentView(viewRouter: viewRouter)
        }
    }
//
//    func configureAmplify() {
//        let dataStorePlugin = AWSDataStorePlugin(modelRegistration: AmplifyModels())
//        do {
//            try Amplify.add(plugin: dataStorePlugin)
//            try Amplify.configure()
//            print("Initialized Amplify");
//        } catch {
//            // simplified error handling for the tutorial
//            print("Could not initialize Amplify: \(error)")
//        }
//    }
    
//    func configureAmplify() {
//
//        do {
//            // storage
//            try Amplify.add(plugin: AWSCognitoAuthPlugin())
//            try Amplify.add (plugin: AWSS3StoragePlugin())
//         //   DataStore
//            let models = AmplifyModels()
//            try Amplify.add (plugin: AWSAPIPlugin (modelRegistration: models))
//            try Amplify.add(plugin: AWSDataStorePlugin(modelRegistration: models))
//            // Configure Plugins
//            try Amplify.configure()
//            print("success amplify")
//
//        } catch {
//            print("could not configure amplify")
//        }
//
//    }
}
