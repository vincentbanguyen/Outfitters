//
//  ClosetView.swift
//  Outfitters
//
//  Created by Vincent Nguyen on 10/30/21.
//

import SwiftUI
import Amplify
import Combine
struct ClosetView: View {
    @State var posts = [Post]()
    
    @State var observationObject: AnyCancellable?

    
    @State var images = [ClothingItem]()
    
    var body: some View {
        
        List {
            ForEach(images) { image in
                if let image = image {
                    Image(uiImage: image.image)
                        .resizable()
                        .scaledToFit()
                }
            }.onDelete(perform: deleteItem)
        }
        
        
//
//        List(imageCache.sorted(by: {$0.key > $1.key}), id: \.key) { key, image in
//            if let image = image {
//                Image(uiImage: image)
//                    .resizable()
//                    .scaledToFit()
//            }
//        }
        
        
        //    var body: some View {
        //        List {
        //            ForEach(posts) { post in
        //
        //                Image(uiImage: downloadImage(post: post)!)
        //
        //                    .resizable()
        //                    .aspectRatio(contentMode: .fill)
        //                    .frame(width: 200, height: 200)
        //                    .cornerRadius(10)
        //                    .overlay(
        //                        Rectangle()
        //                            .foregroundColor(.black)
        //                            .cornerRadius(10)
        //                            .opacity(0.2)
        //                    )
        //
        //            }
        //
        //       .onDelete(perform: deleteItem)
        //
        //
        //        }
    

    .onAppear {
        print("on closet page")
        
        // might move all functions to loading screen]
   
        
        getPosts()
        observePosts()
    }
}

    func deleteItem(indexSet: IndexSet) {
        print("deleted item at \(indexSet)")
        
        var updatedPosts = posts
       updatedPosts.remove(atOffsets: indexSet)
        
        guard let post = Set(updatedPosts).symmetricDifference(posts).first else { return }
        images.remove(atOffsets: indexSet)
        Amplify.DataStore.delete(post) { result in
            switch result {
            case .success:
                print("Post key \(post.imageKey) deleted in datastore at \(indexSet)")
                self.images.remove(atOffsets: indexSet)
            case .failure(let error):
                print("Error deleting post - \(error.localizedDescription)")
            }
        }
        
        Amplify.Storage.remove(key: post.imageKey) { event in
            switch event {
            case let .success(data):
                
                print("Completed: Deleted \(data) and key: \(post.imageKey) in storage")
                
            case let .failure(storageError):
                print("Failed: \(storageError.errorDescription). \(storageError.recoverySuggestion)")
            }
        }
        
        
        
    }
    func getPosts() {
        
  
        
        Amplify.DataStore.query(Post.self) { result in
            switch result {
            case .success(let posts):
              print(posts)
                
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
                self.posts = posts
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
                    print("Progress: \(progress)")
                }, resultListener: { (result) in
                    switch result {
                    case .success(let imageData):
                        
                        let image = UIImage(data: imageData)
                        // let image = UIImage(data: imageData)
                        
                        DispatchQueue.main.async {
                           // self.posts.append(post)
                            images.append(ClothingItem(id: post.imageKey, image: image!, itemType: post.itemType))
                        }
                        
                    case .failure(let error):
                        print("failed to donwload image data")
                    }
                })
        }
    }
    func observePosts() {
        observationObject = Amplify.DataStore.publisher(for: Post.self).sink(
            receiveCompletion: { print($0)},
            receiveValue: { changes in
                guard let post = try? changes.decodeModel(as: Post.self) else { return }
               
                downloadData(for: [post])
                
                switch changes.mutationType {
                case "create":
                    self.posts.append(post)
    

                case "delete":
                    
                    if let index = self.posts.firstIndex(of: post) {
                        print("removing image at \(index)")
                        self.posts.remove(at: index)
                   //     self.images.remove(at: index)
                    }
                default:
                    break
                }


            }
        )
    }
        

}

struct ClosetView_Previews: PreviewProvider {
    static var previews: some View {
        ClosetView()
    }
}
