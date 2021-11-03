//
//  ImagePickerView.swift
//  Outfitters
//
//  Created by Vincent Nguyen on 11/2/21.
//

import Foundation

import UIKit
import SwiftUI

struct ImagePickerView: UIViewControllerRepresentable {
    
    @Binding var selectedImage: UIImage?
    @Environment(\.presentationMode) var isPresented
    var sourceType: UIImagePickerController.SourceType
    typealias UIViewControllerType = UIImagePickerController
        
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = self.sourceType
//        imagePicker.delegate = context.coordinator // confirming the delegate
        return imagePicker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {

    }

    // Connecting the Coordinator class with this struct
    func makeCoordinator() -> ImagePickerCoordinator {
        ImagePickerCoordinator(imagePickerView: self)
    }
}

class ImagePickerCoordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    let imagePickerView: ImagePickerView
    
    init(imagePickerView: ImagePickerView) {
        self.imagePickerView = imagePickerView
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let selectedImage = info[.originalImage] as? UIImage else { return }
        imagePickerView.selectedImage = selectedImage
        self.imagePickerView.isPresented.wrappedValue.dismiss()
    }
    
}
