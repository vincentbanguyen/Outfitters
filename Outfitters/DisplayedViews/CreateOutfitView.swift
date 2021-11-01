//
//  OutfitsView.swift
//  Outfitters
//
//  Created by Vincent Nguyen on 10/31/21.
//

import SwiftUI
import Amplify

struct CreateOutfitView: View {
    @StateObject var viewRouter = ViewRouter()
    @Binding var posts: [String: Post]
    @Binding var tops: [String: ClothingItem]
    @Binding var bottoms: [String: ClothingItem]
    @Binding var shoes: [String: ClothingItem]
    
    
    @State var randomTopsKey = 0
    @Binding var topsKey: String
    @State var modifyingTops = false
    
    @State var randomBottomsKey = 0
    @Binding var bottomsKey: String
    @State var modifyingBottoms = false
    
    @State var randomShoesKey = 0
    @Binding var shoesKey: String
    @State var modifyingShoes = false
    
    @State private var outfitImage: Image? = Image(systemName: "tshirt")
    
    
    let imageSize = 180.0
    
    var body: some View {
        VStack {
            
//            Image(uiImage: tops[Array(tops.keys)[randomTopsKey]]!.image
//                    .overlayWith(image: bottoms[Array(bottoms.keys)[randomBottomsKey]]!.image, posX: 0, posY: CGFloat(bottoms[Array(bottoms.keys)[randomBottomsKey]]!.image.size.height))
//                    .overlayWith(image: shoes[Array(shoes.keys)[randomShoesKey]]!.image, posX: 0, posY: CGFloat(shoes[Array(shoes.keys)[randomShoesKey]]!.image.size.height * 2)))
//                .resizable()
//                .aspectRatio(contentMode: .fit)
//                .cornerRadius(20)
//                .frame(width:  imageSize, height: imageSize * 3)
//                .scaledToFit()
            Button(action: {
              randomizeOutfit()
                modifyingTops = true
            }
                ,label: {
                HStack {
                    Image(systemName: "dice")
                        .font(Font.system(size: 30, weight: .semibold))
                    Text("Randomize")
                        .font(Font.system(size: 30, weight: .semibold))
                }
                .frame(width: 300, height: 60)
                .background(Color.purple)
                .cornerRadius(40)
                .foregroundColor(.white)
            })
            
            
            // TOPS
            HStack {
                Button(action: {
                    modifyingTops = true
                    if randomTopsKey > 0 {
                        randomTopsKey -= 1
                       
                    } else {
                        randomTopsKey = tops.count - 1
                    }
                }, label: {
                    ZStack {
                        Circle()
                            .fill(Color("colorPlus"))
                            .frame(width: 80, height: 80)
                    Image(systemName: "arrow.left")
                            .font(Font.system(size: 40, weight: .semibold))
                            .foregroundColor(.white)
                    }
                })
                if topsKey == "none" || modifyingTops == true {
                    Image(uiImage: tops[Array(tops.keys)[randomTopsKey]]!.image)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .cornerRadius(20)
                        .frame(width:  imageSize, height: imageSize)
                        .scaledToFit()
                }
                else {
                    Image(uiImage: tops[topsKey]!.image)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .cornerRadius(20)
                        .frame(width:  imageSize, height: imageSize)
                        .scaledToFit()
                    
                }
                Button(action: {
                    modifyingTops = true
                    if randomTopsKey < tops.count - 1 {
                        randomTopsKey += 1
                    } else {
                        randomTopsKey = 0
                    }
                }, label: {
                    ZStack {
                        Circle()
                            .fill(Color("colorPlus"))
                            .frame(width: 80, height: 80)
                    Image(systemName: "arrow.right")
                            .font(Font.system(size: 40, weight: .semibold))
                            .foregroundColor(.white)
                    }
                })
                
            }
                
            HStack {
                Button(action: {
                    modifyingBottoms = true
                    if randomBottomsKey > 0 {
                        randomBottomsKey -= 1
                       
                    } else {
                        randomBottomsKey = bottoms.count - 1
                    }
                }, label: {
                    ZStack {
                        Circle()
                            .fill(Color("colorPlus"))
                            .frame(width: 80, height: 80)
                    Image(systemName: "arrow.left")
                            .font(Font.system(size: 40, weight: .semibold))
                            .foregroundColor(.white)
                    }
                })
                if bottomsKey == "none" || modifyingBottoms == true {
                    Image(uiImage: bottoms[Array(bottoms.keys)[randomBottomsKey]]!.image)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .cornerRadius(20)
                        .frame(width:  imageSize, height: imageSize)
                        .scaledToFit()
                }
                else {
                    Image(uiImage: bottoms[bottomsKey]!.image)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .cornerRadius(20)
                        .frame(width:  imageSize, height: imageSize)
                        .scaledToFit()
                    
                }
                Button(action: {
                    modifyingBottoms = true
                    if randomBottomsKey < bottoms.count - 1 {
                        randomBottomsKey += 1
                    } else {
                        randomBottomsKey = 0
                    }
                }, label: {
                    ZStack {
                        Circle()
                            .fill(Color("colorPlus"))
                            .frame(width: 80, height: 80)
                    Image(systemName: "arrow.right")
                            .font(Font.system(size: 40, weight: .semibold))
                            .foregroundColor(.white)
                    }
                })
                
            }
            
            // SHOES
            HStack {
                Button(action: {
                    modifyingShoes = true
                    if randomShoesKey > 0 {
                        randomShoesKey -= 1
                       
                    } else {
                        randomShoesKey = shoes.count - 1
                    }
                }, label: {
                    ZStack {
                        Circle()
                            .fill(Color("colorPlus"))
                            .frame(width: 80, height: 80)
                    Image(systemName: "arrow.left")
                            .font(Font.system(size: 40, weight: .semibold))
                            .foregroundColor(.white)
                    }
                })
                if shoesKey == "none" || modifyingShoes == true {
                    Image(uiImage: shoes[Array(shoes.keys)[randomShoesKey]]!.image)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .cornerRadius(20)
                        .frame(width:  imageSize, height: imageSize)
                        .scaledToFit()
                }
                else {
                    Image(uiImage: shoes[shoesKey]!.image)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .cornerRadius(20)
                        .frame(width:  imageSize, height: imageSize)
                        .scaledToFit()
                    
                }
                Button(action: {
                    modifyingShoes = true
                    if randomShoesKey < shoes.count - 1 {
                        randomShoesKey += 1
                    } else {
                        randomShoesKey = 0
                    }
                }, label: {
                    ZStack {
                        Circle()
                            .fill(Color("colorPlus"))
                            .frame(width: 80, height: 80)
                    Image(systemName: "arrow.right")
                            .font(Font.system(size: 40, weight: .semibold))
                            .foregroundColor(.white)
                    }
                })
                
            }
            
            
       
            Button(action: {
                // SAVE OUTFIT BY SAVING KEYS OF TOPS BOTTOMS SHOES
                
                saveOutfit(tops: modifyingTops ? tops[Array(tops.keys)[randomTopsKey]]!.image : tops[topsKey]!.image  ,
                           bottoms:  modifyingBottoms ? bottoms[Array(bottoms.keys)[randomBottomsKey]]!.image : bottoms[bottomsKey]!.image,
                           shoes:  modifyingShoes ? shoes[Array(shoes.keys)[randomShoesKey]]!.image : shoes[shoesKey]!.image)
            }
                ,label: {
                HStack {
                    Image(systemName: "plus")
                        .font(Font.system(size: 30, weight: .semibold))
                    Text("Add Outfit")
                        .font(Font.system(size: 30, weight: .semibold))
                    
                    
                }
                .frame(width: 300, height: 60)
                .background(Color.purple)
                .cornerRadius(40)
                .foregroundColor(.white)
            })
              
            
            Spacer()
            
       
        }
        .onAppear(perform: {
            print("generating random keys")
           randomizeOutfit()
            
        })
        
        
    }
    
    func saveOutfit(tops: UIImage, bottoms: UIImage, shoes: UIImage) {
        
        outfitImage = tops[Array(tops.keys)[randomTopsKey]]!.image
                .overlayWith(image: bottoms[Array(bottoms.keys)[randomBottomsKey]]!.image, posX: 0, posY: CGFloat(bottoms[Array(bottoms.keys)[randomBottomsKey]]!.image.size.height))
                .overlayWith(image: shoes[Array(shoes.keys)[randomShoesKey]]!.image, posX: 0, posY: CGFloat(shoes[Array(shoes.keys)[randomShoesKey]]!.image.size.height * 2))
        
        uploadToAWS(image: outfitImage, itemType: "outfits")
        
    }
    func randomizeOutfit() {
        modifyingBottoms = true
        modifyingShoes = true
        randomTopsKey =  Int.random(in: 0..<tops.count)
        randomBottomsKey =  Int.random(in: 0..<bottoms.count)
        randomShoesKey =  Int.random(in: 0..<shoes.count)
    }
    
    func uploadToAWS(_ image: UIImage, itemType: String) {
        
        guard let imageData = image.jpegData(compressionQuality: 0.5) else { return }
        let key = UUID().uuidString + ".jpg"
        _ = Amplify.Storage.uploadData(key: key, data: imageData) { result in
            switch result {
            case .success:
                print("@Storage add \(itemType): \(key)   ")
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
                self.outfitImage = nil
                
            case .failure(let error):
                print("failed to save post ")
            }
        }
    }
    
}

//struct OutfitsView_Previews: PreviewProvider {
//    @State static var posts = ["String": Post(id: "hi", imageKey: "hi", itemType: "hi")]
//    @State static var tops = ["53561B6A-FE5E-46E3-99D8-94ECF41DA2B3.jpg": ClothingItem(imageKey: "53561B6A-FE5E-46E3-99D8-94ECF41DA2B3.jpg", image: UIImage(systemName: "tshirt.fill")!, itemType: "tops")]
//    @State static var bottoms = ["53561B6A-FE5E-46E3-99D8-94ECF41DA2B3.jpg": ClothingItem(imageKey: "53561B6A-FE5E-46E3-99D8-94ECF41DA2B3.jpg", image: UIImage(systemName: "tshirt.fill")!, itemType: "bottoms")]
//    @State static var shoes = ["53561B6A-FE5E-46E3-99D8-94ECF41DA2B3.jpg": ClothingItem(imageKey: "53561B6A-FE5E-46E3-99D8-94ECF41DA2B3.jpg", image: UIImage(systemName: "tshirt.fill")!, itemType: "shoes")]
//    static var previews: some View {
//        OutfitsView(tops: $tops, bottoms: $bottoms, shoes: $shoes)
//    }
//}
