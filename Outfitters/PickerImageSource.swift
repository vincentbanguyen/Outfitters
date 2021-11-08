//
//  Picker.swift
//  Outfitters
//
//  Created by Vincent Nguyen on 11/3/21.
//

import Foundation
import UIKit

enum PickerImageSource {
    enum Source: String {
        case library, camera
    }
    
    static func checkPermissions() -> Bool {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            return true
        }
        else {
            return false
        }
    }
}
