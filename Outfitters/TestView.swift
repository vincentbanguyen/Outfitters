//
//  TestView.swift
//  Outfitters
//
//  Created by Vincent Nguyen on 11/3/21.
//
//
//import SwiftUI
//struct TestView: View {
//    
//   
//    
//    @EnvironmentObject var imageVM: ImageViewModel
//    
//    @State var outputImage: UIImage?
//    //@State var testImage: UIImage = UIImage(systemName: "tshirt")!
//    @State var removedBg = false
//   
//    
//    
//    var body: some View {
//        // WARNING: Force wrapped image for demo purpose
//        VStack {
//
//            if let inputImage = imageVM.image  {
////
////                   let _ = print("removed bg \(removedBg)")
////               let _ =     print("is animating \(isAnimating)")
////                let _ = print("CROPPED INPUT IMAGE SIZE: \(inputImage.size)")
//                Image(uiImage: inputImage)
//                    .resizable()
//                    .scaledToFit()
//                    .frame(width: 250, height: 250)
//                    .padding(40)
//                
//            } else {
//               
//                Image(systemName: "tshirt.fill")
//                    .resizable()
//                    .scaledToFit()
//                    .frame(width: 250, height: 250)
//                    .padding(40)
//            }
//            
//            // adding clothing item image
//            
//            HStack {
//                // IMAGE PICKER
//            Button{
//                imageVM.source = .camera
//                imageVM.showPhotoPicker()
//            } label: {
//                HStack {
//                    Image(systemName: "camera")
//                        .font(Font.system(size: 30, weight: .semibold))
//                }
//                
//            }
//            .frame(width: 150, height: 60)
//            .background(Color("colorPlus"))
//            .cornerRadius(40)
//            .foregroundColor(.white)
//                
//                
//                Button{
//                    imageVM.source = .library
//                    imageVM.showPhotoPicker()
//                } label: {
//                    HStack {
//                        Image(systemName: "photo")
//                            .font(Font.system(size: 30, weight: .semibold))
//                    }
//                    
//                }
//                .frame(width: 150, height: 60)
//                .background(Color("colorPlus"))
//                .cornerRadius(40)
//                .foregroundColor(.white)
//                
//                
//                
//            }
//                
//        }
//
//            
//        .sheet(isPresented: $imageVM.showPicker) {
//            ImagePicker(sourceType: imageVM.source == .library ? .photoLibrary : .camera, selectedImage: $imageVM.image)
//                .ignoresSafeArea()
//        }
//        
//   
//    }
//}
