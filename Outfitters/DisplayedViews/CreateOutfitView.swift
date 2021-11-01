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
    
    @Binding var modifyingOutfits: Bool
    
    @State var didSelectSeasonType = false
    let selectedSeasons = ["🌷", "☀️", "🍁","❄️"]
    @State var seasonType = "item"
    @State public var selectedSeasonType: Int?
    
    @State private var outfitImage: UIImage? = UIImage(systemName: "tshirt")
    
    
    let imageSize = 150.0
    
    var body: some View {
        VStack {
    
           
            Button(action: {
              randomizeOutfit()
                modifyingTops = true
                modifyingBottoms = true
                modifyingShoes = true
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
            
            HStack {
                ForEach(0..<selectedSeasons.count, id: \.self) { selectedSeason in
                    Button(action: {
                        self.selectedSeasonType = selectedSeason
                        didSelectSeasonType = true
                        switch selectedSeasonType {
                        case 0:
                        
                            seasonType = "outfitSpring"
                            print(seasonType)
                        case 1:
                            seasonType = "outfitSummer"
                            print(seasonType)
                        case 2:
                            seasonType = "outfitFall"
                            print(seasonType)
                        case 3:
                            seasonType = "outfitWinter"
                            print(seasonType)
                        default:
                            seasonType = "item"
                        }
                    }) {
                        
                        Text("\(selectedSeasons[selectedSeason])")
                            .font(Font.system(size: 30, weight: .semibold))
                           
                    }
                    .frame(width: 60, height: 60)
                    .background(self.selectedSeasonType == selectedSeason ? Color("itemTypeButtonOn") : Color("itemTypeButtonOff"))
                    .cornerRadius(40)
                   // .foregroundColor(self.buttonSelected == selectedType ? Color("itemTypeButtonOn") : Color("itemTypeButtonOff"))
                    .overlay(
                           RoundedRectangle(cornerRadius: 40)
                               .stroke(Color(#colorLiteral(red: 0.2067584602, green: 0.6186007545, blue: 1, alpha: 1)), lineWidth: 5)
                       )
                    .padding(4)
                }
            }
            .padding(4)
 
            
       
            Button(action: {
                // SAVE OUTFIT BY SAVING KEYS OF TOPS BOTTOMS SHOES
                
                saveOutfit(topsImage: modifyingTops ? tops[Array(tops.keys)[randomTopsKey]]!.image : tops[topsKey]!.image  ,
                           bottomsImage:  modifyingBottoms ? bottoms[Array(bottoms.keys)[randomBottomsKey]]!.image : bottoms[bottomsKey]!.image,
                           shoesImage:  modifyingShoes ? shoes[Array(shoes.keys)[randomShoesKey]]!.image : shoes[shoesKey]!.image)
                
                viewRouter.currentPage = .outfits
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
            
            if modifyingOutfits == true {
                modifyingTops = true
                modifyingBottoms = true
                modifyingShoes = true
            }
            
            
        })
        
        
    }
    
    func saveOutfit(topsImage: UIImage, bottomsImage: UIImage, shoesImage: UIImage) {
        if didSelectSeasonType {
        outfitImage = topsImage
                .overlayWith(image: bottomsImage, posX: 0, posY: CGFloat(bottomsImage.size.height))
                .overlayWith(image: shoesImage, posX: 0, posY: CGFloat(shoesImage.size.height * 2))

       
        uploadToAWS(outfitImage!, seasonType: seasonType)
        }
    }
    func randomizeOutfit() {
        
        randomTopsKey =  Int.random(in: 0..<tops.count)
        randomBottomsKey =  Int.random(in: 0..<bottoms.count)
        randomShoesKey =  Int.random(in: 0..<shoes.count)
    }
    
    func uploadToAWS(_ image: UIImage, seasonType: String) {
        
        guard let imageData = image.jpegData(compressionQuality: 0.5) else { return }
        let key = UUID().uuidString + ".jpg"
        _ = Amplify.Storage.uploadData(key: key, data: imageData) { result in
            switch result {
            case .success:
                print("@Storage add \(seasonType): \(key)   ")
                let post = Post(imageKey: key, itemType: seasonType)
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
                print("@DataStore add : \(post.imageKey)")
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
