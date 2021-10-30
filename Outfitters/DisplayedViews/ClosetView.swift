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
    @State var imageCache: [UIImage] = []
    

    @State var token: AnyCancellable?
    var body: some View {
        List(imageCache.indices, id: \.self) { index in
            Image(uiImage: self.imageCache[index])
                .resizable()
                .frame(width: 200, height: 200)
                .cornerRadius(20)
            
        
        }
        
        .onAppear(perform: {
            getPosts()
            observePosts()
        })
    }
    
    
    func getPosts() {
        Amplify.DataStore.query(Post.self) { result in
            switch result {
            case .success(let posts):
                print(posts)
                // download images
                donwloadImages(for: posts)
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func donwloadImages(for posts: [Post]) {
        for post in posts {
            _ = Amplify.Storage.downloadData(key: post.imageKey) { result in
                switch result {
                case .success(let imageData):
                    let image = UIImage(data: imageData)
                    
                    DispatchQueue.main.async {
                        
                        imageCache.append(image!)
                    }
                    
                case .failure(let error):
                    print("failed to donwload image data")
                }
                
            }
        }
    }
    
    func observePosts() {
        token = Amplify.DataStore.publisher(for: Post.self).sink(
            receiveCompletion: { print($0)},
            receiveValue: { event in
                do {
                    let post = try event.decodeModel(as: Post.self)
                    donwloadImages(for: [post])
                    
                } catch {
                    print(error)
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
