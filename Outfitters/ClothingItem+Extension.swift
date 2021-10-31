//
//  ClothingItem.swift
//  Outfitters
//
//  Created by Vincent Nguyen on 10/30/21.
//

import Foundation
import UIKit

struct ClothingItem: Identifiable {
    let id = UUID()
    var imageKey: String
    
    var image: UIImage
    var itemType: String
}
