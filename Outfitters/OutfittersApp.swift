//
//  OutfittersApp.swift
//  Outfitters
//
//  Created by Vincent Nguyen on 10/30/21.
//

import SwiftUI
import Amplify
import AmplifyPlugins
@main
struct OutfittersApp: App {
    
    init() {
        configureAmplify()
    }
    @StateObject var viewRouter = ViewRouter()
    var body: some Scene {
        WindowGroup {
            ContentView(viewRouter: viewRouter)
        }
    }
    
    func configureAmplify() {
        
        do {
            // storage
            try Amplify.add(plugin: AWSCognitoAuthPlugin())
            try Amplify.add (plugin: AWSS3StoragePlugin())
         //   DataStore
            let models = AmplifyModels()
            try Amplify.add (plugin: AWSAPIPlugin (modelRegistration: models))
            try Amplify.add(plugin: AWSDataStorePlugin(modelRegistration: models))
            // Configure Plugins
            try Amplify.configure()
            print("success amplify")
            
        } catch {
            print("could not configure amplify")
        }
        
    }
}
