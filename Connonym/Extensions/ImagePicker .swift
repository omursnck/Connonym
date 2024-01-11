//
//  ImagePicker .swift
//  Connonym
//
//  Created by Ömür Şenocak on 17.12.2023.
//

import Foundation
import SwiftUI
import UIKit


struct ImagePickerRepresentation: UIViewControllerRepresentable {
    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        var parent: ImagePickerRepresentation
        var selectedImage: ((UIImage?) -> Void)

        init(parent: ImagePickerRepresentation, selectedImage: @escaping (UIImage?) -> Void) {
            self.parent = parent
            self.selectedImage = selectedImage
        }

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let uiImage = info[.originalImage] as? UIImage {
                selectedImage(uiImage)
            } else {
                selectedImage(nil)
            }
            parent.presentationMode.wrappedValue.dismiss()
        }

        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            selectedImage(nil)
            parent.presentationMode.wrappedValue.dismiss()
        }
    }

    @Binding var selectedImage: UIImage?
    @Environment(\.presentationMode) var presentationMode

    func makeUIViewController(context: Context) -> UIViewController {
        let viewController = UIViewController()
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = context.coordinator
        viewController.present(imagePickerController, animated: true, completion: nil)
        return viewController
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}

    func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self) { image in
            selectedImage = image
        }
    }
}
