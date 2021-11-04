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
    
    let segmentationService = SegmentationService(apiKey: "717500a714e4abb189ff152656c8189bf8900532")
    
    @StateObject var viewRouter = ViewRouter()
    
    
    @EnvironmentObject var imageVM: ImageViewModel
    
    @State private var isAnimating = false


    var foreverAnimation: Animation {
        Animation.linear(duration: 2.0)
            .repeatForever(autoreverses: false)
    }
    
    @State var processingBg = false
    @State var processingAWS = false

    
    
    @State var outputImage: UIImage?
    //@State var testImage: UIImage = UIImage(systemName: "tshirt")!
    @State var removedBg = false
    @State var didSelectItemType = false
    @State var itemType = "item"

    let selectedTypes = ["👚", "👖", "👟"]
    
    @State public var selectedItemType: Int?
    
    
    var body: some View {
        // WARNING: Force wrapped image for demo purpose
        VStack {
            if removedBg == true {
                if let output = imageVM.image  {
//
//                       let _ = print("removed bg \(removedBg)")
//                   let _ =     print("is animating \(isAnimating)")
              let _ = print("presentng CROPPED output IMAGE SIZE: \(output.size)")
                    Image(uiImage: output)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 250, height: 250)
                        .padding(40)
            }
            }
            else if let inputImage = imageVM.image  {
//
//                   let _ = print("removed bg \(removedBg)")
//               let _ =     print("is animating \(isAnimating)")
//                let _ = print("CROPPED INPUT IMAGE SIZE: \(inputImage.size)")
                Image(uiImage: inputImage)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 250, height: 250)
                    .padding(40)
                
            } else {
               
                Image(systemName: "tshirt.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 250, height: 250)
                    .padding(40)
            }
            
            // adding clothing item image
            
            HStack {
                // IMAGE PICKER
            Button{
                imageVM.source = .camera
                imageVM.showPhotoPicker()
            } label: {
                HStack {
                    Image(systemName: "camera")
                        .font(Font.system(size: 30, weight: .semibold))
                }
                
            }
            .frame(width: 150, height: 60)
            .background(Color("colorPlus"))
            .cornerRadius(40)
            .foregroundColor(.white)
                
                
                Button{
                    imageVM.source = .library
                    imageVM.showPhotoPicker()
                } label: {
                    HStack {
                        Image(systemName: "photo")
                            .font(Font.system(size: 30, weight: .semibold)) 
                    }
                    
                }
                .frame(width: 150, height: 60)
                .background(Color("colorPlus"))
                .cornerRadius(40)
                .foregroundColor(.white)
                
                
                
            }
                
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
            Button {
             
                // removing backgoung

                if imageVM.image != nil && removedBg == false  {
                    if let inputImage = imageVM.image {
                        processingBg = true
                        removeBackground(inputImage: inputImage)
                    }
                }
                // upload to AWS
                else if imageVM.image != nil && removedBg == true && didSelectItemType == true {
                    print("uploading to aws")
             
                        processingAWS = true
                    uploadToAWS(imageVM.image!, itemType: itemType)
//                    let resizedOutputImage = outputImage.scalePreservingAspectRatio(
//                        targetSize: targetSize
//                    )
//
//                    print(resizedOutputImage.size)

                    //upload to aws
                   
                    
                }
            } label: {
                HStack {
                    
                    if removedBg == false && processingBg == false {
                        Image(systemName: "checkmark")
                            .font(Font.system(size: 30, weight: .semibold))
                        Text("Confirm")
                            .font(Font.system(size: 30, weight: .semibold))
                    }
                    
                    else if removedBg == false && processingBg == true {
                        Image(systemName: "arrow.triangle.2.circlepath")
                            .foregroundColor(.white)
                            .font(Font.system(size: 30, weight: .semibold))
                            .rotationEffect(Angle(degrees: self.isAnimating ? 360 : 0.0))
                            .animation(self.isAnimating ? foreverAnimation : .default)
                            .onAppear { self.isAnimating = true }
                            .onDisappear { self.isAnimating = false }
                        Text("Confirm")
                            .font(Font.system(size: 30, weight: .semibold))
                    }
                    
                    
                    
                    else if removedBg == true && processingAWS == false {
                        Image(systemName: "plus")
                            .font(Font.system(size: 30, weight: .semibold))
                        Text("Add to Closet")
                            .font(Font.system(size: 30, weight: .semibold))
                    }
                    
                    else {
                        
                        Image(systemName: "arrow.triangle.2.circlepath")
                            .foregroundColor(.white)
                            .font(Font.system(size: 30, weight: .semibold))
                            .rotationEffect(Angle(degrees: self.isAnimating ? 360 : 0.0))
                            .animation(self.isAnimating ? foreverAnimation : .default)
                            .onAppear { self.isAnimating = true }
                            .onDisappear { self.isAnimating = false }
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
        .sheet(isPresented: $imageVM.showPicker) {
            ImagePicker(sourceType: imageVM.source == .library ? .photoLibrary : .camera, selectedImage: $imageVM.image)
                .ignoresSafeArea()
        }
        
    }
    func removeBackground(inputImage: UIImage) {
        print("trying to remove background")
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
               // outputImage = image
               
                
                let source = image
                let cgSource = source.cgImage
                let my3000dpiImage = UIImage(cgImage: cgSource!, scale: 3000.0 / 72.0, orientation: source.imageOrientation)
                
                imageVM.image = my3000dpiImage
//                print("CROPPED actualy output image size \(image.size)")
//                    //.scalePreservingAspectRatio(targetSize: CGSize(width: 3024, height: 4032))
//
//                print("CROPPED OUTPUT IMAGE SIZE: \( imageVM.image!.size)")
                removedBg = true
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
                DispatchQueue.main.async {
                viewRouter.currentPage = .closet
                imageVM.image = nil
             //   outputImage = nil
                    removedBg = false
                    isAnimating = false
                    didSelectItemType = false
                    processingBg = false
                     processingAWS = false
                print("resetting stuff")
                }
                
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
