//
//  ImageSelectionView.swift
//  class-demo
//
//  Created by OW on 2024/07/17.
//

import SwiftUI

import PhotosUI

struct ImageSelectionView: View {
    
    //image variable
    @State var selectedImageItem: PhotosPickerItem? //image
    @State var selectedPhotoData: Data?
    
    
    var body: some View {
        
        VStack {
            
            PhotosPicker(
                selection: $selectedImageItem,
                matching: .images,
                photoLibrary: .shared()
            ) {
                Text("Select your Image")
            }
            .onChange(of: selectedImageItem) {
                Task{
                    if let data = try? await
                        selectedImageItem?.loadTransferable(type: Data.self) {
                        selectedPhotoData = data //display the image
                    }
                }
            }
            
            //if our image has data, display the image
            if let selectedPhotoData,
               let uiImage = UIImage(data: selectedPhotoData) {
                
                Image(uiImage: uiImage)
                    .resizable().scaledToFit().frame(width: 350, height: 350)
            }
        }
    }
}

#Preview {
    ImageSelectionView()
}
