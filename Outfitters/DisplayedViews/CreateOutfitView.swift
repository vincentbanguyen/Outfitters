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
    
    
    @State private var isAnimating = false


    var foreverAnimation: Animation {
        Animation.linear(duration: 2.0)
            .repeatForever(autoreverses: false)
    }
    
    @State var processingAWS = false
    

    
    
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
    
    
    @State var topsImage = UIImage()
    @State var bottomsImage = UIImage()
    @State var shoesImage = UIImage()
    
    @State private var outfitImage: UIImage? = UIImage(systemName: "tshirt")
    
    
    let imageSize = 150.0
    let circleSize = 60.0

    var body: some View {
        VStack {
            
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
//                        Circle()
//                            .fill(Color("colorPlus"))
//                            .frame(width: circleSize, height: circleSize)
                        arrowLeft()
                    }
                })
                if topsKey == "none" || modifyingTops == true {
                    if let image = tops[Array(tops.keys)[randomTopsKey]]?.image {
                    Image(uiImage: image)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .cornerRadius(20)
                        .frame(width:  imageSize, height: imageSize)
                        .scaledToFit()
                    }
                }
                else {
                    if let image = tops[topsKey]?.image {
                    Image(uiImage: image)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .cornerRadius(20)
                        .frame(width:  imageSize, height: imageSize)
                        .scaledToFit()
                    }
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
//                        Circle()
//                            .fill(Color("colorPlus"))
//                            .frame(width: circleSize, height: circleSize)
                   arrowRight()
                        
                    }
                })
                
            }
                
            // BOTTOMS
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
//                        Circle()
//                            .fill(Color("colorPlus"))
//                            .frame(width: circleSize, height: circleSize)
                  arrowLeft()
                    }
                })
                if bottomsKey == "none" || modifyingBottoms == true {
                    if let image = bottoms[Array(bottoms.keys)[randomBottomsKey]]?.image {
                    Image(uiImage: image)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .cornerRadius(20)
                        .frame(width:  imageSize, height: imageSize)
                        .scaledToFit()
                    }
                }
                else {
                    if let image = bottoms[bottomsKey]?.image {
                    Image(uiImage: image)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .cornerRadius(20)
                        .frame(width:  imageSize, height: imageSize)
                        .scaledToFit()
                    }
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
//                        Circle()
//                            .fill(Color("colorPlus"))
//                            .frame(width: circleSize, height: circleSize)
                  arrowRight()
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
//                        Circle()
//                            .fill(Color("colorPlus"))
//                            .frame(width: circleSize, height: circleSize)
                   arrowLeft()
                    }
                })
                if shoesKey == "none" || modifyingShoes == true {
                    if let image = shoes[Array(shoes.keys)[randomShoesKey]]?.image {
                    Image(uiImage: image)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .cornerRadius(20)
                        .frame(width:  imageSize, height: imageSize)
                        .scaledToFit()
                    }
                }
                else {
                    if let image = shoes[shoesKey]?.image {
                    Image(uiImage: image)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .cornerRadius(20)
                        .frame(width:  imageSize, height: imageSize)
                        .scaledToFit()
                    }
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
//                        Circle()
//                            .fill(Color("colorPlus"))
//                            .frame(width: circleSize, height: circleSize)
                  arrowRight()
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
 
            
            HStack {
                
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
                    }
                    .frame(width: 150, height: 60)
                    .background(Color("colorPlus"))
                    .cornerRadius(40)
                    .foregroundColor(.white)
                })
                
                
            Button(action: {
                // SAVE OUTFIT BY SAVING KEYS OF TOPS BOTTOMS SHOES
                if didSelectSeasonType {
                    if modifyingTops {
                    guard let topsRandom = tops[Array(tops.keys)[randomTopsKey]] else { return }
                        topsImage = topsRandom.image
                    } else {
                        guard let tops = tops[topsKey] else { return }
                        topsImage = tops.image
                    }
                   
                    
                    if modifyingBottoms {
                    guard let bottomsRandom = bottoms[Array(bottoms.keys)[randomBottomsKey]] else { return }
                        bottomsImage = bottomsRandom.image
                    } else {
                        guard let bottoms = bottoms[bottomsKey] else { return }
                        bottomsImage = bottoms.image
                    }
                    
                    if modifyingShoes {
                    guard let shoesRandom = shoes[Array(shoes.keys)[randomShoesKey]] else { return }
                        shoesImage = shoesRandom.image
                    } else {
                        guard let shoes = shoes[shoesKey] else { return }
                        shoesImage = shoes.image
                    }
                    processingAWS = true
                    
                saveOutfit(topsImage: topsImage  ,
                           bottomsImage:  bottomsImage,
                           shoesImage:  shoesImage)
                
               
                }
            }
                ,label: {
                
                
                HStack {
                    if !processingAWS {
                    Image(systemName: "plus")
                        .font(Font.system(size: 30, weight: .semibold))
                    } else {
                        Image(systemName: "arrow.triangle.2.circlepath")
                            .foregroundColor(.white)
                            .font(Font.system(size: 30, weight: .semibold))
                            .rotationEffect(Angle(degrees: self.isAnimating ? 360 : 0.0))
                            .animation(self.isAnimating ? foreverAnimation : .default)
                            .onAppear { self.isAnimating = true }
                            .onDisappear { self.isAnimating = false }
                        
                    }
                    
//                    Text("Add Outfit")
//                        .font(Font.system(size: 30, weight: .semibold))
                    
                    
                }
                .frame(width: 150, height: 60)
                .background(Color("colorPlus"))
                .cornerRadius(40)
                .foregroundColor(.white)
            })
        }
            
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
      
        outfitImage = topsImage
                .overlayWith(image: bottomsImage, posX: 0, posY: CGFloat(bottomsImage.size.height))
                .overlayWith(image: shoesImage, posX: 0, posY: CGFloat(shoesImage.size.height * 2))

        if let outfitImage = outfitImage {
            uploadToAWS(outfitImage, seasonType: seasonType)
        }
        
        
        
    }
    func randomizeOutfit() {
        
        randomTopsKey =  Int.random(in: 0..<tops.count)
        randomBottomsKey =  Int.random(in: 0..<bottoms.count)
        randomShoesKey =  Int.random(in: 0..<shoes.count)
    }
    
    func uploadToAWS(_ image: UIImage, seasonType: String) {
        
        guard let imageData = image.pngData() else { return }
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
                viewRouter.currentPage = .outfits
                
            case .failure(let error):
                print("failed to save post ")
            }
        }
    }
    
}

struct arrowLeft: View {
    var body: some View {
    Image(systemName: "arrow.left")
            .font(Font.system(size: 30, weight: .bold))
            .foregroundColor(Color("colorPlus"))
    }
}

struct arrowRight: View {
    var body: some View {
    Image(systemName: "arrow.right")
            .font(Font.system(size: 30, weight: .bold))
            .foregroundColor(Color("colorPlus"))
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
