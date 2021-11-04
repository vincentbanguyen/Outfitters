//
//  ImagesViewModel.swift
//  Outfitters
//
//  Created by Vincent Nguyen on 11/3/21.
//

import Foundation
import UIKit
import SwiftUI
class ImageViewModel: ObservableObject {
    @Published var image: Image?
    @Published var showPicker = false
    @Published var source: PickerImageSource.Source = .library
    
    func showPhotoPicker() {
        if source == .camera {
            if !PickerImageSource.checkPermissions() {
                print("this boi got no camera")
                return
            }
        }
        showPicker = true
    }
}
