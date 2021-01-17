import SwiftUI
import UIKit

struct ImagePickerController: UIViewControllerRepresentable {
    @Binding var selectedImage: UIImage
    @Binding var showImagePicker: Bool
    @Binding var user: User
    func makeUIViewController(context: Context) -> some UIViewController {
        let controller = UIImagePickerController()
        controller.sourceType = .photoLibrary
        controller.delegate = context.coordinator
        return controller
    }
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        
    }
    func makeCoordinator() -> Coordinator {
        Coordinator(imagePickerController: self)
    }
    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        internal init(imagePickerController: ImagePickerController) {
            self.imagePickerController = imagePickerController
        }
        let imagePickerController: ImagePickerController
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let image = info[.originalImage] as? UIImage {
                imagePickerController.selectedImage = image
                imagePickerController.showImagePicker = false
                imagePickerController.saveImage(image: imagePickerController.selectedImage)
            }
        }
    }
    
    func saveImage(image: UIImage) {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        var fileURL = documentsDirectory.appendingPathComponent(user.imageName)
        do {
            try FileManager.default.removeItem(at: fileURL)
        } catch {
            
        }
        user.imageName = UUID().uuidString
        fileURL = documentsDirectory.appendingPathComponent(user.imageName)
        if let imageData = image.jpegData(compressionQuality: 1.0) {
            try? imageData.write(to: fileURL, options: .atomic)
        }
    }
}
