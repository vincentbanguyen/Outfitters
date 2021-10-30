//
//  AddClothesCiew.swift
//  Outfitters
//
//  Created by Vincent Nguyen on 10/27/21.
//
import Combine
import SwiftUI
import Amplify
import PhotoRoomKit

struct AddClothesView: View {
    @StateObject var viewRouter = ViewRouter()
    
    @State private var image: Image? = Image(systemName: "camera")
    @State private var shouldPresentImagePicker = false
    @State private var shouldPresentActionScheet = false
    @State private var shouldPresentCamera = false
    
    @State var outputImage: UIImage = UIImage(systemName: "camera")!
    @State var testImage: UIImage = UIImage(named: "shirt.png")!
    @State var removedBg = false
    @State var didSelectItemType = false
    @State var itemType = "shirt"
    @State var uploadedImage = false
    
    var body: some View {
        // WARNING: Force wrapped image for demo purpose
        
        VStack {
            if removedBg == false  {
            image!
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 200, height: 200)
            } else {
                Image(uiImage: outputImage)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 200, height: 200)
                
                  
            }
            
            
            // adding clothing item image
            Button(action: {
                self.shouldPresentActionScheet = true
            }) {
                HStack {
                    Image(systemName: "camera")
                    Text("Add Item")
                }
                
            }
            .padding()
            .background(Color(red: 0, green: 0, blue: 0.5))
            .clipShape(Capsule())
            .frame(width: 140, height: 60)
            
            // add buttin optiosn to speicfy item type
            
            // activate remove bg
            Button(action: {
                let inputImage = image.asUIImage()

                // removing backgoung
                if uploadedImage == true && removedBg == false  && didSelectItemType == false {
              
                    
                    // removeBackground(inputImage: inputImage)
                    
                    removedBg = true
                }
                
                
                // upload to AWS
                else {
                    let uploadImage = self.testImage
                        //upload to aws
                    uploadToAWS(uploadImage, itemType: itemType)
                    viewRouter.currentPage = .closet
                    
                }
            }) {
                HStack {
                    
                    if removedBg == false {
                    Image(systemName: "checkmark")
                    Text("Confirm")
                    }
                    else {
                        Image(systemName: "plus")
                        Text("Add to Closet")
                    }
                }
            }
            .padding()
            .background(Color(red: 0, green: 0, blue: 0.5))
            .clipShape(Capsule())
            .foregroundColor(Color.white)
            .frame(width: 140, height: 60)
            
            
            
        }
        .sheet(isPresented: $shouldPresentImagePicker) {
            SUImagePickerView(sourceType: self.shouldPresentCamera ? .camera : .photoLibrary, image: self.$image, isPresented: self.$shouldPresentImagePicker, uploadedImage: $uploadedImage)
        }.actionSheet(isPresented: $shouldPresentActionScheet) { () -> ActionSheet in
            ActionSheet(title: Text("Upload Clothing Item"), buttons: [ActionSheet.Button.default(Text("Camera"), action: {
                self.shouldPresentImagePicker = true
                self.shouldPresentCamera = true
            }), ActionSheet.Button.default(Text("Photo Library"), action: {
                self.shouldPresentImagePicker = true
                self.shouldPresentCamera = false
            }), ActionSheet.Button.cancel()])
        }
        
        
    }
    
    
    
    func removeBackground(inputImage: UIImage) {
        
        let segmentationService = SegmentationService(apiKey: "717500a714e4abb189ff152656c8189bf8900532")
        segmentationService.segment(image: inputImage) { (image, error) in
            DispatchQueue.main.async {
                if let error = error {
                    // An error occured
                }
                guard let image = image else {
                    // No image returned
                    return
                }
                // All good
                outputImage = image
                removedBg = true
            }
        }
        
    }
    
    func uploadToAWS(_ image: UIImage, itemType: String) {
        
        guard let imageData = image.jpegData(compressionQuality: 0.5) else { return }
        let key = UUID().uuidString + ".jpg"
        _ = Amplify.Storage.uploadData(key: key, data: imageData) { result in
            switch result {
            case .success:
                print("Uploaded image \(key) to storage ")
                let post = Post(imageKey: key, itemType: itemType)
                save(post)

            case .failure(let error):
                print("Failed to upload - \(error) ")
            }
        }
    }
    
    func save(_ post: Post) {
        Amplify.DataStore.save(post) { result in
            switch result {
            case .success:
                print("post saved to data store \(post.imageKey)")
                self.image = nil
                
            case .failure(let error):
                print("failed to save post ")
            }
        }
    }
}

struct AddClothesCiew_Previews: PreviewProvider {
    static var previews: some View {
        AddClothesView()
    }
}
