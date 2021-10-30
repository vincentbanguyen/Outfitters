//
//  ContentView.swift
//  Outfitters
//
//  Created by Vincent Nguyen on 10/30/21.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject var viewRouter: ViewRouter
    
    @State var showPopUp = false
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                Spacer()
                switch viewRouter.currentPage {
                case .closet:
                   ClosetView()
                case .outfits:
                    Text("Liked")
                case .addClothes:
                    AddClothesView()
                 
                }
                Spacer()
                ZStack {
                    if showPopUp {
                        PlusMenu(viewRouter: viewRouter, showPopUp: $showPopUp, widthAndHeight: geometry.size.width/7)
                            .offset(y: -geometry.size.height/6)
                    }
                    HStack {
                        TabBarIcon(viewRouter: viewRouter, showPopUp: $showPopUp, assignedPage: .closet, width: geometry.size.width/3, height: geometry.size.height/28, systemIconName: "homekit", tabName: "Closet")
                  
                        ZStack {
                            Circle()
                                .foregroundColor(.white)
                                .frame(width: geometry.size.width/7, height: geometry.size.width/7)
                                .shadow(radius: 4)
                            Image(systemName: "plus.circle.fill")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: geometry.size.width/7-6 , height: geometry.size.width/7-6)
                                .foregroundColor(Color("colorPlus"))
                                .rotationEffect(Angle(degrees: showPopUp ? 90 : 0))
                        }
                            .offset(y: -geometry.size.height/8/2)
                            .onTapGesture {
                                withAnimation {
                                    showPopUp.toggle()
                                }
                            }
                        TabBarIcon(viewRouter: viewRouter, showPopUp: $showPopUp, assignedPage: .outfits, width: geometry.size.width/3, height: geometry.size.height/28, systemIconName: "waveform", tabName: "Outfits")
                   
                    }
                        .frame(width: geometry.size.width, height: geometry.size.height/8)
                    .background(Color("TabBarBackground").shadow(radius: 2))
                }
            }
                .edgesIgnoringSafeArea(.bottom)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(viewRouter: ViewRouter())
            .preferredColorScheme(.light)
    }
}

struct PlusMenu: View {
    @StateObject var viewRouter = ViewRouter()
    
    @Binding var showPopUp: Bool
    let widthAndHeight: CGFloat
    
    var body: some View {
        HStack(spacing: 50) {
            ZStack {
                Circle()
                    .foregroundColor(Color("colorPlus"))
                    .frame(width: widthAndHeight, height: widthAndHeight)
                Image(systemName: "camera")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .padding(15)
                    .frame(width: widthAndHeight, height: widthAndHeight)
                    .foregroundColor(.white)
            }
            .onTapGesture {
                viewRouter.currentPage = .addClothes
                withAnimation {
                    showPopUp = false
                }
                
            }
            ZStack {
                Circle()
                    .foregroundColor(Color("colorPlus"))
                    .frame(width: widthAndHeight, height: widthAndHeight)
                Image(systemName: "folder")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .padding(15)
                    .frame(width: widthAndHeight, height: widthAndHeight)
                    .foregroundColor(.white)
            }
        }
            .transition(.scale)
    }
}

struct TabBarIcon: View {
    @StateObject var viewRouter = ViewRouter()
    @Binding var showPopUp: Bool
    
    let assignedPage: Page
    
    let width, height: CGFloat
    let systemIconName, tabName: String

    var body: some View {
        VStack {
            Image(systemName: systemIconName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: width, height: height)
                .padding(.top, 10)
            Text(tabName)
                .font(.footnote)
            Spacer()
        }
            .padding(.horizontal, -4)
            .onTapGesture {
                viewRouter.currentPage = assignedPage
                withAnimation {
                    showPopUp = false
                }
            }
            .foregroundColor(viewRouter.currentPage == assignedPage ? Color("TabBarHighlight") : .gray)
    }
}
