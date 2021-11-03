//
//  OutfitsView.swift
//  Outfitters
//
//  Created by Vincent Nguyen on 11/1/21.
//

import SwiftUI
import Amplify

struct OutfitsView: View {
    
    enum seasonTypes: String, CaseIterable {
        case spring = "Spring"
        case summer = "Summer"
        case fall = "Fall"
        case winter = "Winter"
    }
    
    @Binding var resetAllData: Bool
    
    @StateObject var viewRouter = ViewRouter()
    @Binding var posts: [String: Post]
    @State var selectedSeasonType: seasonTypes = .winter
    
    
    @Binding var outfitSpring: [String: ClothingItem]
    @Binding var outfitSummer: [String: ClothingItem]
    @Binding var outfitFall: [String: ClothingItem]
    @Binding var outfitWinter: [String: ClothingItem]
    
    @State var promptDelete = false
    
    let imageSize = 180.0
    
    var body: some View {
        NavigationView {
            VStack {
                Picker("Outfits", selection: $selectedSeasonType) {
                    ForEach(seasonTypes.allCases, id: \.self) {
                        Text($0.rawValue)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                
                HStack {
                    
                    if promptDelete == true {
                        Button(action: {
                            deleteDataStore()
                        }, label: {
                            ZStack {
                                Circle().fill(.red).frame(width: 20, height: 20)
                                Image(systemName: "exclamationmark.triangle")
                                    .font(Font.system(size: 10, weight: .semibold))
                                    .foregroundColor(.white)
                            }
                        })
                    }
                    Spacer()
                    Button(action: {
                        withAnimation{
                            promptDelete.toggle()
                        }
                    }, label: {
                        ZStack {
                            Circle().fill(Color("colorPlus")).frame(width: 20, height: 20)
                            Image(systemName: "trash.fill")
                                .font(Font.system(size: 10, weight: .semibold))
                                .foregroundColor(.white)
                        }
                    })
                }
                Spacer()
               ScrollView(.horizontal) {
                    HStack(spacing: 20) {
                        
                        self.listContent(for: getArrayKeys(selectedSeasonType: selectedSeasonType), selectedSeasonType: selectedSeasonType)
                  }
                }
            }
            .navigationTitle("Outfits")
        }
    }
    
    func deleteDataStore() {
        Amplify.DataStore.query(Post.self) { result in
            switch result {
            case .success(let posts):
                print("deleting post POSTS")
                
                
                // to clear datastore/
                for post in posts {
                    Amplify.DataStore.delete(post) { result in
                        switch result {
                        case .success:
                            print("Post key \(post.imageKey) deleted in datastore at")
                            // self.images.remove(atOffsets: indexSet)
                        case .failure(let error):
                            print("Error deleting post - \(error.localizedDescription)")
                        }
                    }
                }
                self.posts.removeAll()
                self.resetAllData = true
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func listContent(for keys: [String], selectedSeasonType: seasonTypes) -> some View {
        ForEach(keys, id: \.self) { key in
            if let key = key {
                
                VStack {
                   
                switch selectedSeasonType {
                case .spring:
                    if let image = self.outfitSpring[key]?.image {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                        
                        .cornerRadius(20)
                        
                }
                case .summer:
                    if let image = self.outfitSummer[key]?.image {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                        
                        .cornerRadius(20)
                        
                }
                case .fall:
                    if let image = self.outfitFall[key]?.image {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                        
                        .cornerRadius(20)
                        
                }  
                case .winter:
                    if let image = self.outfitWinter[key]?.image {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                        
                        .cornerRadius(20)
                        
                }

              
                }
                    if promptDelete {
                        Button(action: {
                            deleteItem(imageKey: key, selectedSeasonType: selectedSeasonType)
                        }, label: {
                            ZStack {
                                Circle().fill(.red).frame(width: 40, height: 40)
                                Image(systemName: "trash.fill")
                                    .font(Font.system(size: 20, weight: .semibold))
                                    .foregroundColor(.white)
                            }
                        })
                    }
                   
                    
                }
                
            }
        }
    }
    
    func getArrayKeys(selectedSeasonType: seasonTypes) -> [String] {
        switch selectedSeasonType {
        case .spring:
            print("spring")
            return Array(outfitSpring.keys)
        case .summer:
            print("summer")
            return Array(outfitSummer.keys)
        case .fall:
            print("fall")
            return Array(outfitFall.keys)
        case .winter:
            print("winter")
            return Array(outfitWinter.keys)
        }
    }
    
    
    func deleteItem(imageKey: String, selectedSeasonType: seasonTypes) {
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
      
        
        switch selectedSeasonType {
        case .spring:
            print("REMOVING SPRING: \(imageKey)")
            self.outfitSpring.removeValue(forKey: imageKey)
        case .summer:
            print("REMOVING SUMMER: \(imageKey)")
            self.outfitSummer.removeValue(forKey: imageKey)
        case .fall:
            print("REMOVING FALL: \(imageKey)")
            self.outfitFall.removeValue(forKey: imageKey)
        case .winter:
            print("REMOVING WINTER: \(imageKey)")
            self.outfitWinter.removeValue(forKey: imageKey)
        }
        
        
    }
    
    
}
    

//struct OutfitsView_Previews: PreviewProvider {
//    static var previews: some View {
//        OutfitsView()
//    }
//}
