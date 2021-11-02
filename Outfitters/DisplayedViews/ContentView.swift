//
//  ContentView.swift
//  Outfitters
//
//  Created by Vincent Nguyen on 10/30/21.
//

import SwiftUI
import Amplify
import Combine

@available(iOS 15.0, *)
struct ContentView: View {
    
    @State var resetAllData = false
    
    @StateObject var viewRouter: ViewRouter
    
    
    
    // instantiaiotn
    @State var observationObject: AnyCancellable?
    @State var tops = [String: ClothingItem]()
    @State var bottoms = [String: ClothingItem]()
    @State var shoes = [String: ClothingItem]()
    
    @State var outfitSpring = [String: ClothingItem]()
    @State var outfitSummer = [String: ClothingItem]()
    @State var outfitFall = [String: ClothingItem]()
    @State var outfitWinter = [String: ClothingItem]()
    
    @State var showPopUp = false
    
    @State var posts = [String: Post]()
    
   
    @State var topsKey = "none"
    @State var bottomsKey = "none"
    @State var shoesKey = "none"
    
    @State var modifyingOutfits = false
    var body: some View {
        GeometryReader { geometry in
            VStack {
                Spacer()
                switch viewRouter.currentPage {
                    
                case .closet:
                    ClosetView(viewRouter: viewRouter, posts: $posts, tops: $tops, bottoms: $bottoms, shoes: $shoes, topsKey: $topsKey, bottomsKey: $bottomsKey, shoesKey: $shoesKey)
                   
                  
                case .outfits:
                    if outfitSpring.count > 0 || outfitSummer.count > 0 || outfitFall.count > 0 || outfitWinter.count > 0 {
                        
                        OutfitsView(resetAllData: $resetAllData, viewRouter: viewRouter, posts: $posts, outfitSpring: $outfitSpring, outfitSummer: $outfitSummer, outfitFall: $outfitFall, outfitWinter: $outfitWinter)
                    }
                    else {
                        Text("Create an outfit first!")
                    }
                    
                case .addClothes:
                   AddClothesView(viewRouter: viewRouter)
                    
                case .addOutfit:
                    if tops.count > 0 && bottoms.count > 0 && shoes.count > 0 {
                        CreateOutfitView(viewRouter: viewRouter, posts: $posts, tops: $tops, bottoms: $bottoms, shoes: $shoes, topsKey: $topsKey, bottomsKey: $bottomsKey, shoesKey: $shoesKey, modifyingOutfits: $modifyingOutfits)
                    }
                    else {
                        Text("Add more items to the closet first!")
                    }
                   
                    
                 
                 
                }
                Spacer()
                ZStack {
                    if showPopUp {
                        PlusMenu(viewRouter: viewRouter, showPopUp: $showPopUp, modifyingOutfits: $modifyingOutfits, widthAndHeight: geometry.size.width/7)
                            .offset(y: -geometry.size.height/6)
                    }
                    HStack {
                        TabBarIcon(viewRouter: viewRouter, showPopUp: $showPopUp, assignedPage: .closet, width: geometry.size.width/3, height: geometry.size.height/28, systemIconName: "house.fill", tabName: "Closet")
                  
                        ZStack {
                            Circle()
                                .foregroundColor(.white)
                                .frame(width: geometry.size.width/7, height: geometry.size.width/7)
                                .shadow(radius: 4)
                            Image(systemName: "plus.circle.fill")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: geometry.size.width/7-6 , height: geometry.size.width/7-6)
                                .foregroundColor(Color("colorPlus"))
                                .rotationEffect(Angle(degrees: showPopUp ? 90 : 0))
                        }
                            .offset(y: -geometry.size.height/8/2)
                            .onTapGesture {
                                withAnimation {
                                    showPopUp.toggle()
                                }
                            }
                        TabBarIcon(viewRouter: viewRouter, showPopUp: $showPopUp, assignedPage: .outfits, width: geometry.size.width/3, height: geometry.size.height/28, systemIconName: "tshirt.fill", tabName: "Outfits")
                   
                    }
                        .frame(width: geometry.size.width, height: geometry.size.height/8)
                    .background(Color("TabBarBackground").shadow(radius: 2))
                }
            }
                .edgesIgnoringSafeArea(.bottom)
        }
        .onAppear(perform: {
            UISegmentedControl.appearance().selectedSegmentTintColor = UIColor(Color("colorPlus"))
            getPosts()
            observePosts()
        })
    }
    
    func getPosts() {
        
        
        
        Amplify.DataStore.query(Post.self) { result in
            switch result {
            case .success(let posts):
                print("GETTING POSTS")
                
                
                //      to clear datastore/
                //                for post in posts {
                //                Amplify.DataStore.delete(post) { result in
                //                    switch result {
                //                    case .success:
                //                        print("Post key \(post.imageKey) deleted in datastore at")
                //                       // self.images.remove(atOffsets: indexSet)
                //                    case .failure(let error):
                //                        print("Error deleting post - \(error.localizedDescription)")
                //                    }
                //                }
                //                }
                
                // download images
                downloadData(for: posts)
                
                //   self.posts = posts
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
    
    func downloadData(for posts: [Post]) {
        
        for post in posts {
            let storageOperation = Amplify.Storage.downloadData(
                key: post.imageKey,
                progressListener: { progress in
                    //     print("Progress: \(progress)")
                }, resultListener: { (result) in
                    switch result {
                    case .success(let imageData):
                        
                        let image = UIImage(data: imageData)
                        // let image = UIImage(data: imageData)
                        
                        DispatchQueue.main.async {
                            // self.posts.append(post)
                            self.posts[post.imageKey] = Post(id: post.id, imageKey: post.imageKey, itemType: post.itemType)
                            print(post.imageKey)
                            
                            switch post.itemType {
                            case "tops":
                                tops[post.imageKey] = ClothingItem(imageKey: post.imageKey, image: image!, itemType: post.itemType)
                            case "bottoms":
                                bottoms[post.imageKey] = ClothingItem(imageKey: post.imageKey, image: image!, itemType: post.itemType)
                            case "shoes":
                                shoes[post.imageKey] = ClothingItem(imageKey: post.imageKey, image: image!, itemType: post.itemType)
                            case "outfitSpring":
                                outfitSpring[post.imageKey] = ClothingItem(imageKey: post.imageKey, image: image!, itemType: post.itemType)
                            case "outfitSummer":
                                outfitSummer[post.imageKey] = ClothingItem(imageKey: post.imageKey, image: image!, itemType: post.itemType)
                            case "outfitFall":
                                outfitFall[post.imageKey] = ClothingItem(imageKey: post.imageKey, image: image!, itemType: post.itemType)
                            case "outfitWinter":
                                outfitWinter[post.imageKey] = ClothingItem(imageKey: post.imageKey, image: image!, itemType: post.itemType)
                            default:
                                print("uh oh no item type")
                            }
                            
                        }
                        
                    case .failure(let error):
                        print("failed to donwload image data")
                        downloadData(for: posts)
                    }
                })
        }
    }
    func observePosts() {
        observationObject = Amplify.DataStore.publisher(for: Post.self).sink(
            receiveCompletion: { print($0)},
            receiveValue: { changes in
                guard let post = try? changes.decodeModel(as: Post.self) else { return }
                
                
                
                switch changes.mutationType {
                case "create":
                    self.posts[post.imageKey] = Post(id: post.id, imageKey: post.imageKey, itemType: post.itemType)
                    downloadData(for: [post])
                    
                case "delete":
                    print("deleted stuff")
                    
                    if resetAllData == true {
                        self.bottoms.removeAll()
                        self.tops.removeAll()
                        self.shoes.removeAll()
                        self.outfitFall.removeAll()
                        self.outfitSpring.removeAll()
                        self.outfitSummer.removeAll()
                        self.outfitWinter.removeAll()
                    }
                    
                default:
                    break
                }
                
                
            }
        )
    }
    
}

@available(iOS 15.0, *)
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(viewRouter: ViewRouter())
            .preferredColorScheme(.light)
    }
}

struct PlusMenu: View {
    @StateObject var viewRouter = ViewRouter()
    
    @Binding var showPopUp: Bool
    
    @Binding var modifyingOutfits: Bool
    
    let widthAndHeight: CGFloat
    
    var body: some View {
        HStack(spacing: 50) {
            ZStack {
                Circle()
                    .foregroundColor(Color("colorPlus"))
                    .frame(width: widthAndHeight, height: widthAndHeight)
                Image(systemName: "camera")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .padding(15)
                    .frame(width: widthAndHeight, height: widthAndHeight)
                    .foregroundColor(.white)
            }
            .onTapGesture {
                viewRouter.currentPage = .addClothes
                withAnimation {
                    showPopUp = false
                }
                
            }
            ZStack {
                Circle()
                    .foregroundColor(Color("colorPlus"))
                    .frame(width: widthAndHeight, height: widthAndHeight)
                Image(systemName: "wand.and.stars.inverse")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .padding(15)
                    .frame(width: widthAndHeight, height: widthAndHeight)
                    .foregroundColor(.white)
            }
            .onTapGesture {
                viewRouter.currentPage = .addOutfit
                modifyingOutfits = true
                
                withAnimation {
                    showPopUp = false
                }
                
            }
        }
            .transition(.scale)
    }
    
    
}

struct TabBarIcon: View {
    @StateObject var viewRouter = ViewRouter()
    @Binding var showPopUp: Bool
    
    let assignedPage: Page
    
    let width, height: CGFloat
    let systemIconName, tabName: String

    var body: some View {
        VStack {
            Image(systemName: systemIconName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: width, height: height)
                .padding(.top, 10)
            Text(tabName)
                .font(.footnote)
            Spacer()
        }
            .padding(.horizontal, -4)
            .onTapGesture {
                viewRouter.currentPage = assignedPage
                withAnimation {
                    showPopUp = false
                }
            }
            .foregroundColor(viewRouter.currentPage == assignedPage ? Color("TabBarHighlight") : .gray)
    }
}
