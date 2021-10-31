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
    @State var posts = [String: Post?]()
    
    @State var observationObject: AnyCancellable?

    
    @State var images = [String: ClothingItem?]()
    
    var body: some View {
        
        List {
            
            ForEach(images.sorted(by: { $0.key > $1.key }), id: \.key) { key, image in
                if let image = image {
                    VStack {
                        Text("\(image.imageKey)")
                    Image(uiImage: image.image)
                        .resizable()
                        .scaledToFit()
                        
                        
                    }
                }
            }
            .onDelete { indexSet in
                let key = Array(images.keys)[indexSet.first!]
                print("removing from \(key) from images " )
             
                deleteItem(imageKey: key)
            }
        }
        
    

    .onAppear {
        print("on closet page")
        
        // might move all functions to loading screen]
   
        
        getPosts()
        observePosts()
    }
}

    
    private func listContent(for keys: [String]) -> some View {
        ForEach(images.sorted(by: { $0.key > $1.key }), id: \.key) { key, image in
            if let image = image {
                VStack {
                    Text("\(image.imageKey)")
                Image(uiImage: image.image)
                    .resizable()
                    .scaledToFit()
                    
                    
                }
            }
        }
          .onDelete { indexSet in
              let key = keys[indexSet.first!]
              deleteItem(imageKey: key)
          }
      }
    
    func deleteItem(imageKey: String) {
        guard let post = self.posts[imageKey] else { return }
        
        print("deleting kwy \(imageKey) ")
        Amplify.DataStore.delete(post!) { result in
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
                
                print("@Stirage remove: \(imageKey)")
                
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
                for post in posts {
                    self.posts[post.imageKey] = Post(id: post.id, imageKey: post.imageKey, itemType: post.itemType)
                }
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
                            images[post.imageKey] = ClothingItem(imageKey: post.imageKey, image: image!, itemType: post.itemType)
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
                    self.posts[post.imageKey] = Post(id: post.id, imageKey: post.imageKey, itemType: post.itemType)
    

                case "delete":
                    
                    self.posts.removeValue(forKey: post.imageKey)
    
                        
                    print("@posts remove: \(post.imageKey)")
                    print("@Images remove: \(post.imageKey)")
          
                  
                    self.images.removeValue(forKey: post.imageKey)
                    
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
