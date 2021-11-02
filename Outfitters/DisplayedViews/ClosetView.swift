//
//  ClosetView.swift
//  Outfitters
//
//  Created by Vincent Nguyen on 10/30/21.
//

import SwiftUI
import Amplify
import Combine
@available(iOS 15.0, *)
struct ClosetView: View {
    
    
    
    @StateObject var viewRouter = ViewRouter()

    @Binding var posts: [String: Post]

    @State var images = [String: ClothingItem]()
    
    @Binding var tops: [String: ClothingItem]
    @Binding var bottoms: [String: ClothingItem]
    @Binding var shoes: [String: ClothingItem]
    
    @Binding var topsKey: String
    @Binding var bottomsKey: String
    @Binding var shoesKey: String
    
    
    enum itemTypes: String, CaseIterable {
        case tops = "Tops"
        case bottoms = "Bottoms"
        case shoes = "Shoes"
    }
    
    @State var selectedItemType: itemTypes = .tops
    var body: some View {
        
        NavigationView {
            VStack {
                Picker("Closet", selection: $selectedItemType) {
                    ForEach(itemTypes.allCases, id: \.self) {
                        Text($0.rawValue)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                List {
                    self.listContent(for: getArrayKeys(selectedItemType: selectedItemType), selectedItemType: selectedItemType)
                }
            }
            .navigationTitle("Closet")
        }
        .onAppear {
            print("on closet page")
            
            // might move all functions to loading screen]
            
            
        }
    }
    
    func getArrayKeys(selectedItemType: itemTypes) -> [String] {
        switch selectedItemType {
        case .tops:
            print("TOPS")
            return Array(tops.keys)
        case .bottoms:
            print("BOTTOMS")
            return Array(bottoms.keys)
        case .shoes:
            print("SHOES")
            return Array(shoes.keys)
        }
    }
    
    private func listContent(for keys: [String], selectedItemType: itemTypes) -> some View {
        ForEach(keys, id: \.self) { key in
            if let key = key {
                
                
                switch selectedItemType {
                case .tops:
                    VStack {
                     
                        Image(uiImage: self.tops[key]!.image)
                            .resizable()
                            .scaledToFit()
                            .cornerRadius(20)
                            .swipeActions(edge: .leading) {
                                
                                Button {
                                    topsKey = key
                                    viewRouter.currentPage = .addOutfit
                                    print("going to add outfit")
                                    
                                } label: {
                                    Label("Create Outfit", systemImage: "wand.and.stars.inverse")
                                }
                                .tint(Color("colorPlus"))
                            }
                        
                            .swipeActions(edge: .trailing) {
                                
                                Button {
                                    print("deleting: \(key)")
                                    deleteItem(imageKey: key, selectedItemType: selectedItemType)
                                    
                                } label: {
                                    Label("Remove Item", systemImage: "trash.fill")
                                }
                                .tint(.red)
                            }
                        
                    }
                case .bottoms:
                    VStack {
                 
                        Image(uiImage: self.bottoms[key]!.image)
                            .resizable()
                            .scaledToFit()
                            .cornerRadius(20)
                            .swipeActions(edge: .leading) {
                                
                                Button {
                                    bottomsKey = key
                                    viewRouter.currentPage = .addOutfit
                                    print("going to add outfit")
                                    
                                } label: {
                                    Label("Create Outfit", systemImage: "wand.and.stars.inverse")
                                }
                                .tint(Color("colorPlus"))
                            }
                        
                            .swipeActions(edge: .trailing) {
                                
                                Button {
                                    print("deleting: \(key)")
                                    deleteItem(imageKey: key, selectedItemType: selectedItemType)
                                    
                                } label: {
                                    Label("Remove Item", systemImage: "trash.fill")
                                }
                                .tint(.red)
                            }
                        
                    }
                case .shoes:
                    VStack {
                  
                        Image(uiImage: self.shoes[key]!.image)
                            .resizable()
                            .scaledToFit()
                            .cornerRadius(20)
                            .swipeActions(edge: .leading) {
                                
                                Button {
                                    shoesKey = key
                                    viewRouter.currentPage = .addOutfit
                                    print("going to add outfit")
                                    
                                } label: {
                                    Label("Create Outfit", systemImage: "wand.and.stars.inverse")
                                }
                                .tint(Color("colorPlus"))
                            }
                        
                            .swipeActions(edge: .trailing) {
                                
                                Button {
                                    print("deleting: \(key)")
                                    deleteItem(imageKey: key, selectedItemType: selectedItemType)
                                    
                                } label: {
                                    Label("Remove Item", systemImage: "trash.fill")
                                }
                                .tint(.red)
                            }
                        
                    }
                }
                
                
            }
        }
        .onDelete { indexSet in
//            let key = keys[indexSet.first!]
//         print("deleting: ")
//            deleteItem(imageKey: key, selectedItemType: selectedItemType)
        }
        
    }
    
    func deleteItem(imageKey: String, selectedItemType: itemTypes) {
        guard let post = self.posts[imageKey] else { return }
        
        Amplify.DataStore.delete(post) { result in
            switch result {
            case .success:
                print("@DataStore remove: \(imageKey)" )
                //     self.images.remove(atOffsets: indexSet)
            case .failure(let error):
                print("Error deleting post - \(error.localizedDescription)")
            }
        }
        
        Amplify.Storage.remove(key: imageKey) { event in
            switch event {
            case let .success(data):
                
                print("@Storage remove: \(imageKey)")
                
            case let .failure(storageError):
                print("Failed: \(storageError.errorDescription). \(storageError.recoverySuggestion)")
            }
        }
        
        self.posts.removeValue(forKey: imageKey)
        
        switch selectedItemType {
        case .tops:
            print("REMOVING TOP: \(imageKey)")
            self.tops.removeValue(forKey: imageKey)
        case .bottoms:
            print("REMOVING BOTTOM: \(imageKey)")
            self.bottoms.removeValue(forKey: imageKey)
        case .shoes:
            print("REMOVING SHOE: \(imageKey)")
            self.shoes.removeValue(forKey: imageKey)
        }
        
        
    }
   
    
}
//
//struct ClosetView_Previews: PreviewProvider {
//    static var previews: some View {
//        ClosetView()
//    }
//}
