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
    typealias SourceType = UIImagePickerController.SourceType
    typealias UIViewControllerType = UIImagePickerController
    
    let sourceType: SourceType
        
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = sourceType
       imagePicker.delegate = context.coordinator // confirming the delegate
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
        
        let image: UIImage? = {
                        if let image = info[.editedImage] as? UIImage {
                            return image
                        }
                        return info[.originalImage] as? UIImage
                    }()
        imagePickerView.selectedImage = selectedImage
        imagePickerView.isPresented.wrappedValue.dismiss()
    }
    
}
