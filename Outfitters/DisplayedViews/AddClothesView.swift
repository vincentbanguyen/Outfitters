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
    
    @State private var image: Image? = Image(systemName: "tshirt")
    @State private var shouldPresentImagePicker = false
    @State private var shouldPresentActionScheet = false
    @State private var shouldPresentCamera = false
    
    @State var outputImage: UIImage = UIImage(systemName: "camera")!
    //@State var testImage: UIImage = UIImage(systemName: "tshirt")!
    @State var removedBg = false
    @State var didSelectItemType = false
    @State var itemType = "item"
    @State var uploadedImage = false
    
    let selectedTypes = ["👚", "👖", "👟"]
    
    @State public var selectedItemType: Int?
    
    
    var body: some View {
        // WARNING: Force wrapped image for demo purpose
        VStack {
            if removedBg == false  {
                if let image = image {
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 250, height: 250)
                    .padding(40)
                }
            } else {
                Image(uiImage: outputImage)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 250, height: 250)
                    .padding(40)
                
                
            }
            
            // adding clothing item image
            Button(action: {
                self.shouldPresentActionScheet = true
            }) {
                HStack {
                    Image(systemName: "camera")
                        .font(Font.system(size: 30, weight: .semibold))
                    Text("Add Item")
                        .font(Font.system(size: 30, weight: .semibold))
                    
                }
                
            }
            .frame(width: 300, height: 60)
            .background(Color("colorPlus"))
            .cornerRadius(40)
            .foregroundColor(.white)
            
            
            //  buttin optiosn to speicfy item type
         
                    .font(Font.system(size: 30, weight: .semibold))
            HStack {
                ForEach(0..<selectedTypes.count, id: \.self) { selectedType in
                    Button(action: {
                        self.selectedItemType = selectedType
                        didSelectItemType = true
                        switch selectedItemType {
                        case 0:
                            itemType = "tops"
                            print(itemType)
                        case 1:
                            itemType = "bottoms"
                            print(itemType)
                        
                        case 2:
                            itemType = "shoes"
                            print(itemType)
                        default:
                            itemType = "item"
                        }
                    }) {
                        
                        Text("\(selectedTypes[selectedType])")
                            .font(Font.system(size: 30, weight: .semibold))
                           
                    }
                    .frame(width: 90, height: 60)
                    .background(self.selectedItemType == selectedType ? Color("itemTypeButtonOn") : Color("itemTypeButtonOff"))
                    .cornerRadius(40)
                   // .foregroundColor(self.buttonSelected == selectedType ? Color("itemTypeButtonOn") : Color("itemTypeButtonOff"))
                    .overlay(
                           RoundedRectangle(cornerRadius: 40)
                               .stroke(Color(#colorLiteral(red: 0.2067584602, green: 0.6186007545, blue: 1, alpha: 1)), lineWidth: 5)
                       )
                    .padding(4)
                }
            }
            .padding(10)

            
            // activate remove bg
            Button(action: {
             
                // removing backgoung
                if uploadedImage == true && removedBg == false  {
                    if let inputImage = self.image {
                        print(inputImage.asUIImage())
                        removeBackground(inputImage: inputImage.asUIImage())
                    }
                    //removedBg = true
                }
                
                // upload to AWS
                else if uploadedImage == true && removedBg == true && didSelectItemType == true {
                    print("uploading to aws")
                    let uploadImage = self.outputImage
                    //upload to aws
                    uploadToAWS(uploadImage, itemType: itemType)
                    viewRouter.currentPage = .closet
                    
                }
            }) {
                HStack {
                    
                    if removedBg == false {
                        Image(systemName: "checkmark")
                            .font(Font.system(size: 30, weight: .semibold))
                        Text("Confirm")
                            .font(Font.system(size: 30, weight: .semibold))
                    }
                    else {
                        Image(systemName: "plus")
                            .font(Font.system(size: 30, weight: .semibold))
                        Text("Add to Closet")
                            .font(Font.system(size: 30, weight: .semibold))
                    }
                }
                .frame(width: 300, height: 60)
                .background(Color.green)
                .cornerRadius(40)
                .foregroundColor(.white)
            }
        }
        .onAppear(perform: {
            print(didSelectItemType)
        })
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
        print("trying to remove background")
        let segmentationService = SegmentationService(apiKey: "717500a714e4abb189ff152656c8189bf8900532")
        segmentationService.segment(image: inputImage) { (image, error) in
            DispatchQueue.main.async {
                if let error = error {
                    // An error occured
                    print("error in removing background")
                    return
                }
                guard let image = image else {
                    // No image returned
                    return
                }
                // All good
                self.outputImage = image
                self.removedBg = true
                print("removed background")
            }
        }
        
    }
    func uploadToAWS(_ image: UIImage, itemType: String) {
        guard let imageData = image.jpegData(compressionQuality: 0.5) else {
            print("cant compress")
            return
            
        }
        let key = UUID().uuidString + ".jpg"
        _ = Amplify.Storage.uploadData(key: key, data: imageData) { result in
            switch result {
            case .success:
                print("@Storage add \(itemType): \(key)  ")
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
                print("@DataStore add \(itemType): \(post.imageKey)")
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
