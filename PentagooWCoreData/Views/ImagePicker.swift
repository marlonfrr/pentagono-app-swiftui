//
//  ImagePicker.swift
//  Pentagono CoreData
//
//  Created by Juan Arengo on 4/04/20.
//  Copyright © 2020 Juan Arango. All rights reserved.
//

import Foundation
import SwiftUI

struct ImagePicker: UIViewControllerRepresentable{
    @Binding var show: Bool
    @Binding var image: Data
    var source: UIImagePickerController.SourceType
    
    
    func makeCoordinator() -> Coordinator {
        return ImagePicker.Coordinator(pconexion:self)
    }
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {
    
    }
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let controller = UIImagePickerController()
        controller.sourceType = source
        controller.allowsEditing = true
        controller.delegate = context.coordinator
        return controller
    }
    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
        var conexion : ImagePicker
        init(pconexion: ImagePicker){
            conexion = pconexion
        }
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            self.conexion.show.toggle()
        }
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            let image = info[.originalImage] as! UIImage
            let data = image.pngData()
            self.conexion.image = data!
            self.conexion.show.toggle()
        }
    }
}

