//
//  VIewRouter.swift
//  Outfitters
//
//  Created by Vincent Nguyen on 10/30/21.
//

import SwiftUI

class ViewRouter: ObservableObject {
    
    @Published var currentPage: Page = .outfits
    
}


enum Page {
    case closet
    case outfits
    case addClothes
}

